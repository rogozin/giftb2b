class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users  do |t|
      t.string :username, :limit => 30
      t.string :email, :limit => 50
      t.string :crypted_password
      t.string :passwort_salt
      t.string :persistence_token
      t.string :fio, :limit=>90
      t.string :phone, :limit=>40
      t.boolean :active, :default => false
      t.active_to :date
      t.integer :login_count, :default => 0, :null => false
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.string :last_login_ip
      t.string :current_login_ip
      t.timestamps
    end
    
    add_index :users, :username
    add_index :users, :persistence_token
    u=User.create(:username=>'admin',:password=>'admin', :password_confirmation => 'admin',:email=>'admin@example.com', :active=>1)
    u.has_role!('Администратор') if u
  end

  def self.down
    drop_table :users
  end
end
