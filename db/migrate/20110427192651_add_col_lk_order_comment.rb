class AddColLkOrderComment < ActiveRecord::Migration
  def self.up
    add_column :lk_orders, :user_comment, :text
  end

  def self.down
    remove_column :lk_orders, :user_comment
  end
end
