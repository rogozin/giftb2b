#encoding: utf-8;
class AddDefaultStoreToSuppliers < ActiveRecord::Migration
  def self.up      
    Supplier.all.each do |s| 
     store=  s.stores.find_or_create_by_name("основной") 
     execute("insert into store_units (store_id, product_id, count, updated_at) ( select #{store.id}, id, store_count, now() from products p where p.store_count > 0 and p.supplier_id = #{s.id} )")         
   end     
#    Product.where("store_count > 0").each{|p| StoreUnit.create(:product_id => p.id, :store_id => p.supplier.stores.first.id, :count => p.store_count)}
  end

  def self.down
    StoreUnit.all.each{|s|s.destroy}
  end
end
