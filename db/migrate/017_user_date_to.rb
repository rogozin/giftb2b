class UserDateTo < ActiveRecord::Migration
  def self.up
    add_column :users, :expire_date, :date
  end

  def self.down
    remove_column :users, :expire_date
  end
end
