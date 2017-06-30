class AddSubscriptionToRssFeed < ActiveRecord::Migration
  def change
    add_reference :rss_feeds, :subscription, index: true, foreign_key: true
  end
end
