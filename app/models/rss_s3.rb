class RssS3 < ActiveRecord::Base
  belongs_to :project
  has_attached_file :file

end
