class AddProjectToRssS3s < ActiveRecord::Migration
  def change
    add_reference :rss_s3s, :project, index: true, foreign_key: true
  end
end
