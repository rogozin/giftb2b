class CreateContentCategories < ActiveRecord::Migration
  def self.up
    create_table :content_categories do |t|
      t.string :name, :size => 255, :null => false
      t.string :permalink, :size => 255, :null => false
      t.timestamps
    end
    add_index :content_categories, :permalink, :unique => true
  end

  def self.down
    drop_table :content_categories
  end
end
