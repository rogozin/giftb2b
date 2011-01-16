class CreateCommercialOffers < ActiveRecord::Migration
  def self.up
    create_table :commercial_offers do |t|
      t.integer :firm_id
      t.integer :sale
      t.string :to
      t.string :addr
      t.string :email
      t.text :signature
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :commercial_offers
  end
end
