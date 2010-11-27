class CreatePropertyCategories < ActiveRecord::Migration
  def self.up
    create_table :property_categories, :id=>false do |t|
      t.integer :property_id
      t.integer :category_id
    end
      add_index :property_categories, [:property_id,:category_id], :unique=>true 
  end

  def self.down
    drop_table :property_categories
  end
end
