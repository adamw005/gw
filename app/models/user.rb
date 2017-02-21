class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	has_many :projects
	before_create :create_avatar

	def create_avatar
		self.avatar = 'https://api.adorable.io/avatars/64/' + (0...8).map { (65 + rand(36)).chr }.join
	end

end
