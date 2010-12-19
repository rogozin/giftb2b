class AddColCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :show_description, :boolean, :default => false
    add_column :categories, :meta_keywords, :string
    add_column :categories, :meta_description, :string
  end

  def self.down
    remove_column :categories, :show_description,  :meta_description, :meta_keywords
  end
end
