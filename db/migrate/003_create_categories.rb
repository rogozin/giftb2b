class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.integer :parent_id
      t.string :name, :limit => 80
      t.boolean :active, :default =>true
      t.integer :sort_order,:default =>100
      t.string :meta
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
