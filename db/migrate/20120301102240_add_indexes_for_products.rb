class AddIndexesForProducts < ActiveRecord::Migration
  def up
    add_index :products, :article
    add_index :products, :price
    add_index :products, :ruprice
    add_index :products, :sort_order
    add_index :products, :manufactor_id
    
    add_index :lk_products, :firm_id
    add_index :lk_products, :product_id
    add_index :lk_products, :article
    add_index :lk_products, :active
    add_index :lk_products, :show_on_site
    add_index :lk_products, :store_count
    
    add_index :lk_firms, :firm_id
    
    add_index :commercial_offers, :firm_id
    add_index :commercial_offer_items, :commercial_offer_id
    add_index :commercial_offer_items, :lk_product_id
    
    add_index :lk_orders, :firm_id
    
    add_index :news, :firm_id
    
    add_index :samples, :firm_id    
  end

  def down
    remove_index :products, :article
    remove_index :products, :price
    remove_index :products, :ruprice
    remove_index :products, :sort_order
    remove_index :products, :manufactor_id
    
    remove_index :lk_products, :firm_id
    remove_index :lk_products, :product_id
    remove_index :lk_products, :article
    remove_index :lk_products, :active
    remove_index :lk_products, :show_on_site
    remove_index :lk_products, :store_count
    
    remove_index :lk_firms, :firm_id
    
    remove_index :commercial_offers, :firm_id
    remove_index :commercial_offer_items, :commercial_offer_id
    remove_index :commercial_offer_items, :lk_product_id
    
    remove_index :lk_orders, :firm_id
    
    remove_index :news, :firm_id
    
    remove_index :samples, :firm_id        
  end
end
