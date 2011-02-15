class AddColsUser < ActiveRecord::Migration
  def self.up
    add_column :users, :appoint, :string, :size => 100
    add_column :users, :skype, :string, :size => 25
    add_column :users, :icq, :string, :size => 25
    add_column :users, :cellphone, :string, :size => 25
    
    
  end

  def self.down
    remove_column :users, :appoint, :skype, :icq, :cellphone
  end
end
