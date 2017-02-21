class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :title
      t.text :body
      t.decimal :amount
      t.references :project, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
