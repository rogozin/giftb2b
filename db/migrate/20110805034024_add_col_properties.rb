class AddColProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :for_search, :boolean, :default => false
    add_column :properties, :for_all_products, :boolean, :default => false
  end

  def self.down
    remove_column :properties, :for_search, :for_all_products
  end
end
