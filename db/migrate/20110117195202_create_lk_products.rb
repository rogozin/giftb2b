class CreateLkProducts < ActiveRecord::Migration
  def self.up
    create_table :lk_products do |t|
      t.integer :firm_id
      t.integer :product_id
      t.string :article
      t.string :short_name
      t.text :description
      t.decimal :price, :precision=>10, :scale => 2, :default => 0
      t.string :color
      t.string :size
      t.string :factur
      t.string :box
      t.string :infliction
      t.string :picture_file_name
      t.string :picture_content_type
      t.integer :picture_file_size
      t.datetime :picture_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :lk_products
  end
end
