class AddColProductsIsNew < ActiveRecord::Migration
  def self.up
    add_column :products, :is_new, :boolean, :default => false
    
    Product.order("created_at desc").limit(30).each{ |p| p.update_attribute(:is_new, true)}
  end

  def self.down
    remove_column :products, :is_new
  end
end
