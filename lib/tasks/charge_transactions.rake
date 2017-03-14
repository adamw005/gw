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

			# Loop through each grouped User in the TransactionQueue
			@users_with_amounts.each do |u|
				total_amount_owed = u.amount
				amount_in_balance = 0
				# Withdrawl from Account.Balance first


				# Charge the remaining amount to StripeInfo.customer_id
			end

	    puts "Finished charging transactions..."
  	end


	end
end


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
