class AddFileToRssS3 < ActiveRecord::Migration
  def change
    add_attachment :rss_s3s, :file
  end
end
