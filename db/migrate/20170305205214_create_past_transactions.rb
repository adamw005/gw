class CreatePastTransactions < ActiveRecord::Migration
  def change
    create_table :past_transactions do |t|
      t.string :type
      t.decimal :amount
      t.references :project, index: true, foreign_key: true
      t.string :status
      t.references :user, index: true, foreign_key: true
      t.references :rewards_tier, index: true, foreign_key: true
      t.references :release, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
