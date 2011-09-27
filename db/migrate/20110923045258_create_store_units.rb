class CreateStoreUnits < ActiveRecord::Migration
  def self.up
    create_table :store_units, :id => false do |t|
      t.integer :store_id, :null => false
      t.integer :product_id, :null => false
      t.integer :count, :default => 0
      t.datetime :updated_at
    end
      add_index  :store_units, [:store_id, :product_id], :unique => true
      add_index :store_units, :product_id
      add_index :store_units, :store_id

  end

  def self.down
    drop_table :store_units
  end
end
