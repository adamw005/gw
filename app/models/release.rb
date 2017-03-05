class Release < ActiveRecord::Base
  belongs_to :project
	has_many :subscriptions
	has_many :transaction_queues
	has_many :past_transactions
end
