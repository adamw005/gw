class Account < ActiveRecord::Base
	obfuscate_id :spin => 72894092
  belongs_to :user
	has_many :balances, dependent: :destroy
	has_many :stripe_infos, dependent: :destroy
	has_many :bank_infos, dependent: :destroy
end
