class AddColProductsBestPrice < ActiveRecord::Migration
  def self.up
    add_column :products, :best_price, :boolean, :default => false
    add_index :products, :best_price
  end

  def self.down
    remove_column :products, :best_price
  end
end
