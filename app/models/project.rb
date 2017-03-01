class Project < ActiveRecord::Base
  belongs_to :user
	has_many :subscriptions,  dependent: :destroy
	has_many :posts,  dependent: :destroy
	has_many :comments,  dependent: :destroy
	has_many :rewards_tiers,  dependent: :destroy
	has_many :goals,  dependent: :destroy
	accepts_nested_attributes_for :rewards_tiers
	accepts_nested_attributes_for :goals
	has_attached_file :box_image, styles: { medium: "300x300#", thumb: "100x100#" }, default_url: "/assets/:style/missing.png"
 	validates_attachment_content_type :box_image, content_type: /\Aimage\/.*\z/
	after_save :destroy_original

	def amount_sum
		Subscription.where(project_id: self.id).sum(:amount)
	end


	private

	def destroy_original
	  File.unlink(self.photo.path)
	end

end
