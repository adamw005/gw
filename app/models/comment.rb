class Comment < ActiveRecord::Base
	# obfuscate_id :spin => 72894092
  belongs_to :project
  belongs_to :user
end
