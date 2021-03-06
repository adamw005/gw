class Subscription < ActiveRecord::Base
	# obfuscate_id :spin => 72894092
  belongs_to :project
  belongs_to :user
	belongs_to :rewards_tier
  has_many :rss_feeds
	validates_uniqueness_of :user_id, scope: :rewards_tier_id
	scope :monthly_subscriptions, -> { where(type: 'MonthlySubscription') }
	scope :release_subscriptions, -> { where(type: 'ReleaseSubscription') }

	# We will need a way to know which subscriptions will subclass the Subscription model
	def self.types
		%w(MonthlySubscription ReleaseSubscription)
	end

end
