class PropertyTypes < ActiveRecord::Migration
  def self.up
      add_column :properties, :property_type, :integer, :default=>0, :null=>false
  end

  def self.down
    remove_column :properties, :property_type
  end
end
