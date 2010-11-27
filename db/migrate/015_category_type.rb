class CategoryType < ActiveRecord::Migration
  def self.up
    add_column :categories, :kind, :integer, :default=>1
  end

  def self.down
    remove_column :categories, :kind
  end
end
