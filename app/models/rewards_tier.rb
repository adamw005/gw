class RewardsTier < ActiveRecord::Base
  belongs_to :project
	has_many :subscriptions
	has_many :transactoin_queues
	has_many :past_transactions
	before_create :set_title

def set_title
	if project.charge_occurrence == 'episodic' then occ = 'episode' else occ = 'month' end
  self.title = 'Pledge $' + min_amount.round.to_s + ' or more per ' + occ
end

end
