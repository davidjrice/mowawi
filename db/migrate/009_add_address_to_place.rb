class AddAddressToPlace < ActiveRecord::Migration
  def self.up
    add_column :places, :address, :string
  end

  def self.down
    remove_column :places, :address
  end
end
