class AddCustomerIdToStripeInfo < ActiveRecord::Migration
  def change
    add_column :stripe_infos, :customer_id, :string
  end
end
