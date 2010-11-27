class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name, :limit => 40
      t.integer :group, :default=>0
      t.integer :authorizable_id
      t.integer :authorizable_type
    end
    create_table :roles_users, :id => false, :force => true do |t|
      t.references  :user
      t.references  :role
    end
    Role.create(:name=>"Администратор")
    Role.create(:name=>"Менеджер")
    Role.create(:name=>"Редактор")
    Role.create(:name=>"Пользователь",:group=>1)
  end

  def self.down
    drop_table :roles_users
    drop_table :roles
  end
end
