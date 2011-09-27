class CreateStores < ActiveRecord::Migration
  def self.up
    create_table :stores do |t|
      t.integer :supplier_id
      t.string :name
      t.string :location
      t.string :delivery_time
      t.timestamps
    end
  end

  def self.down
    drop_table :stores
  end
end
