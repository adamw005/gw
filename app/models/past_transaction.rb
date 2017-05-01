class PastTransaction < ActiveRecord::Base
	obfuscate_id :spin => 72894092
  belongs_to :project
  belongs_to :user
  belongs_to :reward_tier
  belongs_to :release
end
