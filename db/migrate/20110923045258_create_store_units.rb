class CreateStoreUnits < ActiveRecord::Migration
  def self.up
    create_table :store_units, :id => false do |t|
      t.integer :store_id, :null => false
      t.integer :product_id, :null => false
      t.integer :count, :default => 0
      t.time :updated_at
    end
      add_index  :store_units, [:store_id, :product_id], :unique => true

  end

  def self.down
    drop_table :store_units
  end
end
