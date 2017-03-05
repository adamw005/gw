class TransactionQueue < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :reward_tier
  belongs_to :release
end
