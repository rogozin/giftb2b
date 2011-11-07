class AddColBanners < ActiveRecord::Migration
  def up
    add_column :banners, :position, :integer, :default => 1
    add_column :banners, :site, :integer, :default => 0
    add_column :banners, :pages, :text
  end

  def down
    remove_columns :banners, :position, :site, :pages
  end
end
