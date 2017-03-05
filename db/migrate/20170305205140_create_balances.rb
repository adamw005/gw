class CreateBalances < ActiveRecord::Migration
  def change
    create_table :balances do |t|
      t.references :account, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
