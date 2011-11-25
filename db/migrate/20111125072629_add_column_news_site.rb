class AddColumnNewsSite < ActiveRecord::Migration
  def up
    add_column :news, :site, :integer, :default => 0
  end

  def down
    remove_column :news, :site
  end
end
