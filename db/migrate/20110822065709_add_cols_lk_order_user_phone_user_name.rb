class AddColsLkOrderUserPhoneUserName < ActiveRecord::Migration
  def self.up
    add_column :lk_orders, :user_phone, :string
    add_column :lk_orders, :user_name, :string
  end

  def self.down
    remove_column :lk_orders, :user_phone, :user_name
  end
end
