class AddColumnsToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :type, :string
    add_reference :subscriptions, :rewards_tier, index: true, foreign_key: true
    add_reference :subscriptions, :release, index: true, foreign_key: true
  end
end
