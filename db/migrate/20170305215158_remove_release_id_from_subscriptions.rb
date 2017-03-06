class RemoveReleaseIdFromSubscriptions < ActiveRecord::Migration
  def change
		remove_column :subscriptions, :release_id
  end
end
