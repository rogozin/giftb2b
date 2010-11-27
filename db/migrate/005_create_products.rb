class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.integer :manufactor_id
      t.integer :supplier_id
      t.string :article, :limit => 100
      t.string :short_name, :limit => 100
      t.string :full_name, :limit => 100
      t.string :size, :limit=>30
      t.string :color, :limit=>20
      t.string :factur, :limit=>100
      t.string :box, :limit=>30
      t.decimal :price, :precision=>10, :scale => 2, :default => 0
      t.integer :sort_order, :default=>100       
      t.integer :store_count, :default=>0
      t.integer :remote_store_count, :default=>0
      t.boolean :from_store, :default=>1
      t.boolean :from_remote_store,:default=>0
      t.boolean :active, :default=>1     
      t.text :description
      t.string :meta
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end

