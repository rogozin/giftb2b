class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :type
      t.string :picture_file_name
      t.string :picture_content_type
      t.integer :picture_file_size
      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end

