class ChangeTableUsersForAuthlogic < ActiveRecord::Migration
  def self.up
    rename_column :users, :crypted_password, :encrypted_password

    add_column :users, :confirmation_token, :string, :limit => 255
    add_column :users, :confirmed_at, :timestamp
    add_column :users, :confirmation_sent_at, :timestamp
    execute "UPDATE users SET confirmed_at = created_at, confirmation_sent_at = created_at"
    add_column :users, :reset_password_token, :string, :limit => 255    
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :remember_token, :string, :limit => 255
    add_column :users, :remember_created_at, :timestamp
    add_column :users, :authentication_token, :string

    rename_column :users, :login_count, :sign_in_count
    rename_column :users, :current_login_at, :current_sign_in_at
    rename_column :users, :last_login_at, :last_sign_in_at
    rename_column :users, :current_login_ip, :current_sign_in_ip
    rename_column :users, :last_login_ip, :last_sign_in_ip

    remove_column :users, :persistence_token
    remove_column :users, :perishable_token    

    add_index :users, :email,                :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :authentication_token, :unique => true
  end

  def self.down

  end
end
