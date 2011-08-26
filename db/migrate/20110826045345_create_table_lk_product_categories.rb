class CreateTableLkProductCategories < ActiveRecord::Migration
  def self.up
    create_table :lk_product_categories, :id => false do |t|     
      t.integer :lk_product_id
      t.integer :category_id
    end
    add_index :lk_product_categories, [:lk_product_id, :category_id], :unique => true
  end

  def self.down
    drop_table :lk_product_categories
  end
end
