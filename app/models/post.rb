class Post < ActiveRecord::Base
	# obfuscate_id :spin => 72894092
  belongs_to :project
  has_one :rss_s3
end
