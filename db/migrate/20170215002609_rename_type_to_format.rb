class RenameTypeToFormat < ActiveRecord::Migration
  def change
		rename_column :projects, :type, :format
  end
end
