class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
	has_many :projects, dependent: :destroy
	has_many :accounts, dependent: :destroy
	has_many :subscriptions, dependent: :destroy
	has_many :comments, dependent: :destroy
	has_many :transaction_queues
	has_many :past_transactions
	belongs_to :country
	delegate :monthly_subscriptions, :release_subscriptions, to: :subscriptions
	delegate :monthly_transaction_queues, :release_transaction_queues, to: :transaction_queues
	before_create :create_avatar
	# Virtual attribute for authenticating by either username or email
	# This is in addition to a real persisted field like 'username'
	attr_accessor :login
	validates :username, :presence => true, :uniqueness => { :case_sensitive => false }
	# Only allow letter, number, underscore and punctuation.
	validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
	# Must accept Terms of Service
	validates :tos, acceptance: { accept: true }

	def create_avatar
		self.avatar = 'https://api.adorable.io/avatars/64/' + (0...8).map { (65 + rand(26)).chr }.join
	end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
		conditions[:email].downcase! if conditions[:email]
		if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_hash).first
    end
  end

end
