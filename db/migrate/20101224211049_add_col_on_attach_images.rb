class AddColOnAttachImages < ActiveRecord::Migration
  def self.up
    add_column :attach_images, :main_img, :boolean, :default => false
  end

  def self.down
    remove_column :attach_images, :main_img
  end
end
