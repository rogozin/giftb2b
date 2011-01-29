class CreateLkOrderItems < ActiveRecord::Migration
  def self.up
    create_table :lk_order_items do |t|
      t.integer :lk_order_id
      t.integer :product_id
      t.string :product_type
      t.integer :quantity
      t.decimal :price, :precision=>10, :scale => 2, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :lk_order_items
  end
end
