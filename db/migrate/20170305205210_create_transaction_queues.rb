class CreateTransactionQueues < ActiveRecord::Migration
  def change
    create_table :transaction_queues do |t|
      t.string :type
      t.decimal :amount
      t.references :project, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :rewards_tier, index: true, foreign_key: true
      t.references :release, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
