class Project < ActiveRecord::Base
  belongs_to :user
	has_many :subscriptions
	has_many :posts
	has_many :comments
	has_many :rewards_tiers
	has_many :goals
	accepts_nested_attributes_for :rewards_tiers
	accepts_nested_attributes_for :goals

	def amount_sum
		Subscription.where(project_id: self.id).sum(:amount)
	end

end
