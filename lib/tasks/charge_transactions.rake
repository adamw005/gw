namespace :charge_transactions do

  desc "Everyday check to see if it's the 1st of the month and attemp transaction charges"
  task :start => :environment do

		### Charge Transactions ###
		if (1..5).include?(Time.now.day)
	    puts "Attempting to charge TransactionQueues"

			# Group TransactionQueue by User with summed amounts
			@users_with_amounts = TransactionQueue.group(:user).sum(:amount)

			# Group TransactionQueue by User-Project with amounts owed
			@user_projects_with_proportions = TransactionQueue.group(:user).group(:project).sum(:amount)
			# TODO Get the proportions

			# Loop through each grouped User in the TransactionQueue
			@users_with_amounts.each do |u|
				total_amount_owed = u.amount
				amount_in_balance = Balance.where(account_id: u.accounts).first.amount

				# Withdrawl from Account.Balance first
				if amount_in_balance > 0
					# Calculate amount to remove from balance
					amount_to_debit_balance = [amount_in_balance, total_amount_owed].min

					# Debit Subscribers Account
					# TODO Wrap this in a transaction to credt project owners, and deduct the 5% (and do what with it)
					Balance.where(account_id: u.accounts).first.amount -= amount_to_debit_balance

					# Update total_amount_owed
					total_amount_owed -= amount_to_debit_balance
				end

				# Charge the remaining amount to StripeInfo.customer_id
				stripe_cust_id = StripeInfo.where(account_id: u.accounts).first

				charge = Stripe::Charge.create(
					:customer    => stripe_cust_id,
					:amount      => total_amount_owed,
					:description => 'Groundwork Subscription Charge',
					:currency    => 'usd',
					# :application_fee => TODO (total_amount_owed*.05).round,
					:transfer_group => 100 # TODO unique order id

				)

				# If charge was successful
				if charge["paid"] == true
					proportions = @user_projects_with_proportions.where(user_id: u.id)

					# Round amounts and credit each Project.users.account.balance (Project Owner's account)
					# loop through each Project.user to create a transfer for each Project Owner
					proportions.project_id.each do |p|
						# Take the amount_charged and multiply it by User-Project.proportion
						amount_to_transfer = total_amount_owed * proportions.proportion.where(project_id: p.id).first

						# Set project_owner variable for later
						project_owner = p.user

						# TODO Create Transfers here
						transfer = Stripe::Transfer.create({
						  :amount => amount_to_transfer,
						  :currency => "usd",
						  :destination => StripeInfo.where(account_id: project_owners.accounts.first.id).first.stripe_id
						  # :transfer_group => # TODO unique order id,
						})
					end

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



# [] Fill in the TODOs
# [] When a User creates a Project, if StripeInfo.account_id is nil use Stripe::Account.create and store account_id, secret_key, shareable_key




# [x] Are we using Stripe Platform Account.Yes
# [x] Not Now: I need to create `Charges` Controller and Model to keep track of and issue charges
# [x] I need to get a Stripe Platform Account and see how that works. Do my Project Owners have to have Stripe accounts?
# [x] How do I determine the Stripe fee? It looks like I pass the amount I want the user to end up with instead of the amount I keep, can I pass in that I want to keep x amount?

# How do we move transactions from Queue to Past? Grouped or no? No, same as in Queue + status
# charge_transactions
	# If it's the first-fifth of the month, after the snapshots have finished
		# Group TransactionQueue table by User, sum(amount) as total_amount_owed
		# Separately, group TransactionQueue table by User-Project and get proportion of each Project's amount for the User
		# Next, if User.account.balance > 0 deduct upto total_amount_owed from balance
		# Charge remaining total_amount_owed to StripeInfo.customer_id
		# If charge is successful
			# Take the amount_charged - 5% and multiply it by User-Project.proportion
			# Round amounts and credit each Project.users.account.balance (Project Owner's account)
			# Copy all of User's TransactionQueue records to PastTransaction with 'successful' status
		# If charge is unsuccessful
			# Leave the User's records in TransactionQueue
	# If it's the fifth of the month (after the above code has finished for the 5th day this month)
		# # Copy all TransactionQueue records to PastTransaction with 'failed' status
