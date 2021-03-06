class Project < ActiveRecord::Base
	# obfuscate_id :spin => 72894092
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
	before_save :assign_slug

	def amount_sum
		Subscription.where(project_id: self.id).sum(:amount)
	end

	def self.search(search)
  	where("title ILIKE ? OR body ILIKE ?", "%#{search}%", "%#{search}%")
	end

	private

	# Create url slug
	def assign_slug
		if Project.where(slug: title.parameterize('')).exists?
			self.slug = title.parameterize('') + Random.rand(999).to_s
		else
			self.slug = title.parameterize('')
 		end
	end

end
