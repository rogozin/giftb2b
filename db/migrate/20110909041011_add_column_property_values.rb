class AddColumnPropertyValues < ActiveRecord::Migration
  def self.up
    add_column :property_values, :sort_order, :integer, :default => 1
    add_column :property_values, :group_order, :integer, :default => 1
  end

  def self.down
    remove_columns :property_values, :sort_order, :group_order
  end
end
