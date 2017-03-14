class AddAmountToBalance < ActiveRecord::Migration
  def change
    add_column :balances, :amount, :numeric
  end
end
