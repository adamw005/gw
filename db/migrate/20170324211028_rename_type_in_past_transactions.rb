class RenameTypeInPastTransactions < ActiveRecord::Migration
  def change
		rename_column :past_transactions, :type, :type_of
  end
end
