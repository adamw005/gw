class CreateRewardsTiers < ActiveRecord::Migration
  def change
    create_table :rewards_tiers do |t|
      t.integer :level
      t.string :title
      t.text :body
      t.decimal :min_amount
      t.references :project, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
