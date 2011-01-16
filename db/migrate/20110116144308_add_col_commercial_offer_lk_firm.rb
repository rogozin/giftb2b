class AddColCommercialOfferLkFirm < ActiveRecord::Migration
  def self.up
    add_column :commercial_offers, :lk_firm_id, :integer
    remove_column :commercial_offers, :to, :addr
    change_column :commercial_offers, :sale, :integer, :default =>0
  end

  def self.down
    remove_column :commercial_offers, :lk_firm_id
    add_column :commercial_offers, :to, :string
    add_column :commercial_offers, :addr, :string
  end
end
