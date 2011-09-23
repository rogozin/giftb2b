#encoding: utf-8;
class AddDefaultStoreToSuppliers < ActiveRecord::Migration
  def self.up
    Supplier.all.each{|s| s.stores.create(:name => "основной") }
    Product.where("store_count > 0").each{|p| StoreUnit.create(:product_id => p.id, :store_id => p.supplier.stores.first.id, :count => p.store_count)}
  end

  def self.down
    Store.all.each{|s|s.destroy}
  end
end
