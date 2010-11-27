class CreateProductCategories < ActiveRecord::Migration
  def self.up
    create_table :product_categories,:id=>false do |t|
     t.integer :product_id
     t.integer :category_id 
    end
   add_index :product_categories, [:product_id,:category_id], :unique=>true 
  end

  def self.down
    drop_table :product_categories
  end
end
