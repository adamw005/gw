class RssS3 < ActiveRecord::Base
  include Hashid::Rails
  belongs_to :project
  has_attached_file :file
  do_not_validate_attachment_file_type :file

end
