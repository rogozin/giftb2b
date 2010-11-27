class CreateProperties < ActiveRecord::Migration
  def self.up
    create_table :properties do |t|
      t.string :name, :limit => 40
      t.boolean :active, :default => true
      t.integer :sort_order, :default => 100
      t.timestamps
    end
  end

  def self.down
    drop_table :properties
  end
end
