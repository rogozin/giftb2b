class AddColCommercialOfferItemSale < ActiveRecord::Migration
  def up
    add_column :commercial_offer_items, :sale, :integer, :default => 0
    CommercialOffer.where("sale > 0").each do |co|
      co.commercial_offer_items.update_all(:sale => co.sale)
    end
    remove_column :commercial_offers, :sale    
  end

  def down
    add_column :commercial_offers, :sale, :integer, :default => 0
    remove_column :commercial_offer_items, :sale
  end
end
