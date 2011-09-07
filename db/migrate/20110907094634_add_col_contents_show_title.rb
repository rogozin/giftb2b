class AddColContentsShowTitle < ActiveRecord::Migration
  def self.up
    add_column :contents, :show_title, :boolean, :default => true
  end

  def self.down
    remove_column :contents, :show_title
  end
end
