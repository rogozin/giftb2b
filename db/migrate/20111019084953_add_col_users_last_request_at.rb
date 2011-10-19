class AddColUsersLastRequestAt < ActiveRecord::Migration
  def up
    add_column :users, :last_request_at, :datetime
  end

  def down
    remove_column :users, :last_request_at
  end
end
