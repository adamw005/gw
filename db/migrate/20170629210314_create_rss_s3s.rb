class CreateRssS3s < ActiveRecord::Migration
  def change
    create_table :rss_s3s do |t|
      

      t.timestamps null: false
    end
  end
end
