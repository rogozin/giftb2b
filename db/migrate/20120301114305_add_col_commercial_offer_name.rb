class AddColCommercialOfferName < ActiveRecord::Migration
  def up
    add_column :commercial_offers, :name, :string
  end

  def down
   remove_column :commercial_offers, :name
  end
end
