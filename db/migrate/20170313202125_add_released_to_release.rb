class AddReleasedToRelease < ActiveRecord::Migration
  def change
    add_column :releases, :released, :boolean, :default => false
  end
end
