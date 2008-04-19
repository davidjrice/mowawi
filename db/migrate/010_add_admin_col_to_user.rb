class AddAdminColToUser < ActiveRecord::Migration
  class User < ActiveRecord::Base; end
  
  def self.up
    add_column :users, :admin, :boolean, :default => false
    # make me an admin
    me = User.find_by_login('davidjrice')
    me.update_attribute(:admin, true)
    puts me.inspect
  end

  def self.down
    remove_column :users, :admin
  end
end
