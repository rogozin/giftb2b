class AddColProductIsSale < ActiveRecord::Migration
  def self.up
    add_column :products, :is_sale, :boolean, :default => false
  end

  def self.down
    remove_column :products, :is_sale
  end
end
