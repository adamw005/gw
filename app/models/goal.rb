class Goal < ActiveRecord::Base
	# obfuscate_id :spin => 72894092
  belongs_to :project
end
