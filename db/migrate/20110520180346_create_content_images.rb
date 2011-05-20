class CreateContentImages < ActiveRecord::Migration
  def self.up
    create_table :content_images do |t|
      t.string :gallery_item_file_name
      t.string :gallery_item_content_type
      t.integer :gallery_item_file_size

      t.timestamps
    end
  end

  def self.down
    drop_table :content_images
  end
end
