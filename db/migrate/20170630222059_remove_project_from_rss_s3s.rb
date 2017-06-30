class RemoveProjectFromRssS3s < ActiveRecord::Migration
  def change
    remove_reference(:rss_s3s, :project, index: true, foreign_key: true)
    add_reference :rss_s3s, :post, index: true, foreign_key: true
  end
end
