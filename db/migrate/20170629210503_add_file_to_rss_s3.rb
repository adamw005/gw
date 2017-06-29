class AddFileToRssS3 < ActiveRecord::Migration
  def change
    add_attachment :rss_s3, :file
  end
end
