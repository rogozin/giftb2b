class AddColumnsForCategories < ActiveRecord::Migration
  def up
    add_column :categories, :custom_title, :string
    change_column :categories, :meta_keywords, :text
    change_column :categories, :meta_description, :text
  end

  def down
    remove_column :categories, :custom_title
    change_column :categories, :meta_keywords, :string
    change_column :categories, :meta_description, :string 
  end
end
