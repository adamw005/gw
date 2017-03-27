class RemoveUserIdFromCountries < ActiveRecord::Migration
  def change
    remove_reference :countries, :user, index: true
  end
end
