class AddColUsersUrl < ActiveRecord::Migration
  def up
    add_column :users, :url, :string
  end

  def down
    remove_column :users, :url
  end
end
