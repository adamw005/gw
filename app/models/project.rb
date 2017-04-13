class Project < ActiveRecord::Base
  belongs_to :user
	has_many :subscriptions,  dependent: :destroy
	has_many :posts,  dependent: :destroy
	has_many :comments,  dependent: :destroy
	has_many :rewards_tiers,  dependent: :destroy
	has_many :goals,  dependent: :destroy
	has_many :transaction_queues
	has_many :releases
	has_many :past_transactions
	delegate :monthly_subscriptions, :release_subscriptions, to: :subscriptions
	delegate :monthly_transaction_queues, :release_transaction_queues, to: :transaction_queues
	accepts_nested_attributes_for :rewards_tiers
	accepts_nested_attributes_for :goals
	has_attached_file :box_image, styles: { original: "300x300#", medium: "300x300#", thumb: "100x100#" }, default_url: "/assets/:style/missing.png"
 	validates_attachment_content_type :box_image, content_type: /\Aimage\/.*\z/
	# URL Slug creation
	after_create :assign_slug
	before_update :assign_slug

	def amount_sum
		Subscription.where(project_id: self.id).sum(:amount)
	end

	private

	# Create url slug
	def assign_slug
		self.slug = parameterize(title, '')
	end

end
