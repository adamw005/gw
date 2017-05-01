class RewardsTier < ActiveRecord::Base
	# obfuscate_id :spin => 72894092
  belongs_to :project
	has_many :subscriptions
	has_many :transactoin_queues
	has_many :past_transactions
	before_create :set_title
	delegate :monthly_subscriptions, :release_subscriptions, to: :subscriptions
	delegate :monthly_transaction_queues, :release_transaction_queues, to: :transaction_queues

	def set_title
		if project.charge_occurrence == 'episodic' then occ = 'episode' else occ = 'month' end
	  self.title = 'Pledge $' + min_amount.round.to_s + ' or more per ' + occ
	end

end
