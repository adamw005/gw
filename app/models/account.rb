class Account < ActiveRecord::Base
  belongs_to :user
	has_many :balances, dependent: :destroy
	has_many :stripe_infos, dependent: :destroy
	has_many :bank_infos, dependent: :destroy
end
