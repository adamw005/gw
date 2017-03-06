class Subscription < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
	belongs_to :rewards_tier
	scope :monthly_subscriptions, -> { where(type: 'MonthlySubscription') }
	scope :release_subscriptions, -> { where(race: 'ReleaseSubscription') }

	# We will need a way to know which subscriptions will subclass the Subscription model
	def self.types
		%w(MonthlySubscription ReleaseSubscription)
	end

end
