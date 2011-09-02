class AddColCategoriesOutline < ActiveRecord::Migration
  def self.up
    add_column :categories, :outline, :boolean, :default => false
  end

  def self.down
    remove_column :categories, :outline
  end
end
