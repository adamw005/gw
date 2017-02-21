class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :stripe_customer_nbr, :text
    add_column :users, :paypal_customer_nbr, :text
  end
end
