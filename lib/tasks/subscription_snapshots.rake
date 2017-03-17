# Every day run this rake task

# The ReleaseSubscription table needs to be snapshot at the end of every day, and MonthlySubscription at the end of every month
	# Release is daily bc a project can only have one release per day, and after a release is created we need to take a snapshot for the queue
# After these run, then we process the TransactionQueues table
# subscription_snapshots.rake => 	Copy ReleaseSubscription and MonthlySubscription to ReleaseTransactionQueue and MonthlyTransactionQueue
# charge_transactions.rake =>			Go through TransactionQueue table, grouped by User, and charge Account.balance then Stripe API. Move records from
	# TransactionQueue to PastTransaction once succesful. Repeat for 5 days or until all records are processed succesfully (moved to PastTransaction)

namespace :subscription_snapshots do
  desc "Everyday create Release Snapshots and if it's the 1st of the month create Monthly Snapshots"
  task :start => :environment do


		### Monthly Subscription snapshot ###
		if Time.now.day == 1
	    puts "Attempting to snapshot MonthlyTransactionQueue"

			# Create a snapshot of MonthlySubscription and copy to MonthlyTransactionQueue
			MonthlySubscription.find_each do |sub|
			  MonthlyTransactionQueue.create(sub.attributes)
			end

	    puts "Finished snapshot of MonthlyTransactionQueue"
  	end

		### Release Subscription snapshot ###
	    puts "Attempting to snapshot ReleaseTransactionQueue"

			# Create a snapshot of ReleaseSubscription records with Release.released == false and copy to ReleaseTransactionQueue
			ReleaseTransactionQueue.transaction do
				ReleaseSubscription.joins(project: :releases).where(releases: {released: false}).each do |sub|
					sub = sub.attributes
					sub.delete("type")
					sub["type"] = 'ReleaseSubscription'
					ReleaseTransactionQueue.create(sub)
				end
			end

	    puts "Finished snapshot of ReleaseTransactionQueue"


	end
end


# Article.joins(comments: :guest)
# ReleaseSubscription.joins(project: :releases)

# MonthlySubscription.joins(project: :releases).where(releases: {released: false})

# old:
# ReleaseSubscription.find_each.where(released: false) do |s|
# 	ReleaseTransactionQueue.create(s)
# end


# sql = "
# insert into transaction_queues
# select a.*, b.id as release_id
#  from subscriptions a
#  left join releases b
#   on a.project_id = b.project_id
#  where b.released = false
#  and a.type = 'ReleaseSubscription'
#  "
#
# sql = "select * from Subscription a left join releases b on a.project_id = b.project_id where b.released == false and a.type = 'ReleaseSubscription'"
# records_array = ActiveRecord::Base.connection.execute(sql)

# I though find_each was supposed to be a more efficient way
# so just
# ```
# @monthly_subs = MonthlySubscription.all
# MonthlyTransactionQueue.create(@monthly_subs)
# ```

# [] Add released to Release

# 2 files/rake tasks. subscription_snapshots.rake and charge_transactions.rake
# subscription_snapshots
	# monthly_sub_snapshot
		# If it's the first of the month, create a snapshot of MonthlySubscription and copy to MonthlyTransactionQueue
		# Subscription is a live table of all current Subscriptions, TransactionQueue is a snapshot of a month's to-do transactions, PastTransaction shows past transactions that have been through TransactionQueue and have succeeded or failed
	# release_sub_snapshot
		# No matter what day it is, create a snapshot of ReleaseSubscription records with Release.released == false and copy to ReleaseTransactionQueue
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
