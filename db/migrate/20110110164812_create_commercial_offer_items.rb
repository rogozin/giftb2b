class CreateCommercialOfferItems < ActiveRecord::Migration
  def self.up
    create_table :commercial_offer_items do |t|
      t.integer :commercial_offer_id
      t.integer :product_id
      t.integer :quantity
      t.decimal :price, :precision=>10, :scale => 2, :default => 0
      t.text :description
      t.text :remark
    end
  end

  def self.down
    drop_table :commercial_offer_items
  end
end
