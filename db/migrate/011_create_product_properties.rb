class CreateProductProperties < ActiveRecord::Migration
  def self.up
    create_table :product_properties, :id=>false do |t|
      t.integer :property_value_id
      t.integer :product_id
      t.timestamps
    end
   add_index :product_properties, [:property_value_id, :product_id], :unique => true 
  end

  def self.down  
    drop_table :product_properties
  end
end
