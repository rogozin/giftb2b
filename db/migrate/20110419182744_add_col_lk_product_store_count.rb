class AddColLkProductStoreCount < ActiveRecord::Migration
  def self.up
    add_column :lk_products, :store_count, :integer, :default => 0
    LkProduct.all.each do |lkp|
      lkp.update_attribute(:store_count, lkp.product.store_count) if lkp.product
    end
  end

  def self.down
    remove_column :lk_products, :store_count
  end
end
