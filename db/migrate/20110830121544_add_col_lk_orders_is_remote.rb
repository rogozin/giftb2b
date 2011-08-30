class AddColLkOrdersIsRemote < ActiveRecord::Migration
  def self.up
    add_column :lk_orders, :is_remote, :boolean, :default =>false
  end

  def self.down
    remove_column :lk_orders, :is_remote
  end
end
