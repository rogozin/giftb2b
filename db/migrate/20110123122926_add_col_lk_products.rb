class AddColLkProducts < ActiveRecord::Migration
  def self.up
    add_column :lk_products, :active, :boolean, :default => true
    add_column :commercial_offer_items, :lk_product_id, :integer
    remove_column :commercial_offer_items, :product_id, :price, :description, :remark
  end

  def self.down
    remove_column :lk_products, :active
    remove_column :commercial_offer_items, :lk_product_id
    add_column :commercial_offer_items, :product_id, :integer
    add_column :commercial_offer_items, :price, :decimal
    add_column :commercial_offer_items, :description, :text
    add_column :commercial_offer_items, :remark, :text
  end
end
