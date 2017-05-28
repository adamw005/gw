class TransactionQueue < ActiveRecord::Base
	# obfuscate_id :spin => 72894092
  belongs_to :project
  belongs_to :user
  belongs_to :reward_tier
  belongs_to :release
	scope :monthly_transaction_queues, -> { where(type: 'MonthlyTransactionQueue') }
	scope :release_transaction_queues, -> { where(race: 'ReleaseTransactionQueue') }

	# We will need a way to know which subscriptions will subclass the Subscription model
	def self.types
		%w(MonthlyTransactionQueue ReleaseTransactionQueue)
	end

end
