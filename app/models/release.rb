class Release < ActiveRecord::Base
  belongs_to :project
	has_many :transaction_queues
	has_many :past_transactions
	delegate :monthly_subscriptions, :release_subscriptions, to: :subscriptions
	delegate :monthly_transaction_queues, :release_transaction_queues, to: :transaction_queues

end
