class AddColumnsToStripeInfo < ActiveRecord::Migration
  def change
    add_column :stripe_infos, :stripe_id, :string
    add_column :stripe_infos, :secret_key, :string
    add_column :stripe_infos, :publishable_key, :string
  end
end
