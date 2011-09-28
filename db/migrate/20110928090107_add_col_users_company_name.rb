class AddColUsersCompanyName < ActiveRecord::Migration
  def self.up
    add_column :users, :company_name,:string
    add_column :users, :city,:string
  end

  def self.down
    remove_column :users, :company_name
    remove_column :users, :city
  end
end
