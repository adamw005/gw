class AddProjectIdToRssS3 < ActiveRecord::Migration
  def change
    add_reference :rss_s3s, :project, index: true
  end
end
