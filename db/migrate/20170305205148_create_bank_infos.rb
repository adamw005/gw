class CreateBankInfos < ActiveRecord::Migration
  def change
    create_table :bank_infos do |t|
      t.string :bank_num
      t.string :routing_num
      t.references :account, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
