class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.integer :content_category_id
      t.string :title, :size => 255, :null => false
      t.text :body   
      t.boolean :draft, :default => false 
      t.boolean :frezee, :default => false     
      t.string :permalink, :limit => 255, :null => false
      t.datetime :start
      t.datetime :stop
      t.string :meta_keywords
      t.string :meta_description
      t.timestamps
    end

    add_index :contents, :permalink, :unique => true
  end

  def self.down
    drop_table :contents
  end
end
