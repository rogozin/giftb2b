class VirtualCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :virtual_id, :integer
  end

  def self.down
    remove_column :categories, :virtual_id
  end
end
