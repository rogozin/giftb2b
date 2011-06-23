class AddColLkOrdersUserEmail < ActiveRecord::Migration
  def self.up
    add_column :lk_orders, :user_email, :string, :size => 50
  end

  def self.down
    remove_column :lk_orders, :user_email
  end
end
