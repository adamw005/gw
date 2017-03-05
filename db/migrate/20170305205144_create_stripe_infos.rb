class CreateStripeInfos < ActiveRecord::Migration
  def change
    create_table :stripe_infos do |t|
      t.references :account, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
