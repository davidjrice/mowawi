class AddIntroReadToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :read_intro, :boolean, :default => false
  end

  def self.down
    remove_column :users, :read_intro
  end
end
