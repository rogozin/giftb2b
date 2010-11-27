class CreateAttachImages < ActiveRecord::Migration
  def self.up
      create_table :attach_images, :id=>false do |t|
      t.integer :attachable_id
      t.string :attachable_type
      t.integer :image_id
    end
    add_index(:attach_images, [:attachable_id, :attachable_type, :image_id], :unique=>true,:name=> 'attach_images_uniq')
  end

  def self.down
    drop_table :attach_images
  end
end

