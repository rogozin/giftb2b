class AddColLkProductsShowProductOnMySite < ActiveRecord::Migration
  def self.up
    add_column :lk_products, :show_on_site, :boolean, :default => false
  end

  def self.down
    remove_column :lk_products, :show_on_site
  end
end
