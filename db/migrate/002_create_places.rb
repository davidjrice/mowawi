class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.column :title, :string
      t.column :lat, :decimal, :precision => 15, :scale => 10
      t.column :lng, :decimal, :precision => 15, :scale => 10
    end
  end

  def self.down
    drop_table :places
  end
end
