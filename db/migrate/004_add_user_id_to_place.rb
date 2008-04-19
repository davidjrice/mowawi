class AddUserIdToPlace < ActiveRecord::Migration
  def self.up
    add_column :places, :user_id, :integer
  end

  def self.down
    remove_column :places, :user_id
  end
end
