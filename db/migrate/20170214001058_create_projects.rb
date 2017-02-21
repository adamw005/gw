class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.string :type
      t.text :body
      t.text :charge_occurrence
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
