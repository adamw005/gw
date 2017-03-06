class Subscription < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
	belongs_to :rewards_tier
	validates_uniqueness_of :user_id, scope: :rewards_tier_id
	scope :monthly_subscriptions, -> { where(type: 'MonthlySubscription') }
	scope :release_subscriptions, -> { where(type: 'ReleaseSubscription') }

	# We will need a way to know which subscriptions will subclass the Subscription model
	def self.types
		%w(MonthlySubscription ReleaseSubscription)
	end

end
