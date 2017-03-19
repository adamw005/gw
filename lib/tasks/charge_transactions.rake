namespace :charge_transactions do

  desc "Everyday check to see if it's the 1st of the month and attemp transaction charges"
  task :start => :environment do

		### Charge Transactions ###
		if (1..18).include?(Time.now.day)
	    puts "Attempting to charge TransactionQueues"

			# Group TransactionQueue by User with summed amounts
			@users_with_amounts = TransactionQueue.group(:user).sum(:amount)

			# Loop through each grouped User in the TransactionQueue
			@users_with_amounts.each do |u,amount|
				total_amount_owed = amount.to_i
				# amount_in_balance = Balance.where(account_id: u.accounts).first.amount

				# Group TransactionQueue by User-Project with amounts owed to get proportions of debts per project
				user_projects_with_amounts = TransactionQueue.where(user_id: u.id).group(:user_id).group(:project_id).sum(:amount)
				user_sum = TransactionQueue.where(user_id: u.id).group(:user).sum(:amount).first[1]
				@user_projects_with_proportions = []
				puts "1"
				user_projects_with_amounts.each do |up, s|
					puts "2"
					new_hash = {}
					new_hash[:user] = up[0]
					new_hash[:project] = up[1]
					new_hash[:proportion] = s/user_sum
					@user_projects_with_proportions << new_hash
				end

				# Create Invoice Number (Transfer Group) that doesn't exist yet
				invoice_number = [*('a'..'z'),*('0'..'9')].shuffle[0,16].join
				while PastTransaction.where(status: invoice_number).first
					invoice_number = [*('a'..'z'),*('0'..'9')].shuffle[0,16].join
				end

				# # TODO Withdrawl from Account.Balance first
				# if amount_in_balance > 0
				# 	# Calculate amount to remove from balance
				# 	amount_to_debit_balance = [amount_in_balance, total_amount_owed].min
				#
				# 	# Debit Subscribers Account & Credit Project Owners
				# 	# TODO Wrap this in a transaction to credt project owners, and deduct the 5% (and do what with it)
				# 	Balance.transaction
				# 		Balance.where(account_id: u.accounts).first.amount -= amount_to_debit_balance
				#
				# 	end
				#
				# 	# Update total_amount_owed
				# 	total_amount_owed -= amount_to_debit_balance
				# end

				# Charge the remaining amount to StripeInfo.customer_id
				stripe_cust_id = StripeInfo.where(account_id: u.accounts).first.customer_id

				charge = Stripe::Charge.create(
					:customer    => stripe_cust_id,
					:amount      => total_amount_owed,
					:description => 'Groundwork Subscription Charge',
					:currency    => 'usd',
					:transfer_group => invoice_number
				)

				puts "3"

				# If charge was successful
				if charge["paid"] == true
					proportions = @user_projects_with_proportions

					# Round amounts and credit each Project.users.account.balance (Project Owner's account)
					# loop through each Project.user to create a transfer for each Project Owner
					proportions.each do |proj|
						puts proj
						# Take the amount_charged and multiply it by User-Project.proportion
						amount_to_transfer = (total_amount_owed * proj[:proportion]).round

						# Set project_owner variable for later
						project_owner = Project.find(proj[:project]).user
						puts project_owner

						# Create Stripe Transfer
						transfer = Stripe::Transfer.create({
						  :amount => amount_to_transfer,
						  :currency => "usd",
						  :destination => StripeInfo.where(account_id: project_owner.accounts.first.id).first.stripe_id,
							:application_fee => (amount_to_transfer*0.05).round,
							:source_transaction => charge[:charge_id]
						  # :transfer_group => invoice_number
						})
					end
					puts "4"

					# Copy all of User's TransactionQueue records to PastTransaction with 'successful' status
					TransactionQueue.transaction do # transaction ensures both actions below complete or none do
						TransactionQueue.where(user_id: u.id) do |t| # loop through a user's TransactionQueue records
							PastTransaction.create(t.attributes, status: 'successful') # copy + status field
							t.destroy # remove from TransactionQueue
						end
					end

				# If charge failed
				else
					# Leave the record in TransactionQueue until day 5, then move it to PastTransaction with `status` of 'failed'
					if Time.now.day == 5
						# Grab all TransactionQueue records for this loop's user(u) and move them to PastTransaction
						TransactionQueue.transaction do # transaction ensures both actions below complete or none do
							TransactionQueue.where(user_id: u.id) do |t| # loop through a user's TransactionQueue records
								PastTransaction.create(t.attributes, status: 'failed') # copy + status field
								t.destroy # remove from TransactionQueue
								# TransactionQueue.destroy(t.id) # remove from TransactionQueue
							end
						end
					end

				end

			end

	    puts "Finished charging transactions..."
  	end


	end
end
