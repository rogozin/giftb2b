class CrIndexProductProperties < ActiveRecord::Migration
  def self.up
    add_index :product_properties, :property_value_id
    add_index :product_properties, :product_id
  end

  def self.down
    remove_index :product_properties, :property_value_id
    remove_index :product_properties, :product_id
  end
end
