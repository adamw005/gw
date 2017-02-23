class Project < ActiveRecord::Base
  belongs_to :user
	has_many :subscriptions
	has_many :posts
	has_many :comments
	has_many :rewards_tiers
	has_many :goals
	accepts_nested_attributes_for :rewards_tiers
	accepts_nested_attributes_for :goals
	has_attached_file :box_image, styles: { medium: "300x300#", thumb: "100x100#" }, default_url: "/assets/:style/missing.png"
 	validates_attachment_content_type :box_image, content_type: /\Aimage\/.*\z/

	def amount_sum
		Subscription.where(project_id: self.id).sum(:amount)
	end

end
