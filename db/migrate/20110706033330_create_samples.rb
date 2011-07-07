#encoding: utf-8;
class CreateSamples < ActiveRecord::Migration
  def self.up
    create_table :samples, :force => true do |t|
      t.string :name
      t.integer :supplier_id
      t.decimal :buy_price, :precision=>10, :scale => 2, :default => 0
      t.decimal :sale_price, :precision=>10, :scale => 2, :default => 0
      t.integer :firm_id
      t.date :buy_date
      t.date :sale_date
      t.date :supplier_return_date
      t.date :client_return_date
      t.integer :user_id
      t.timestamps
    end
    
   # Factory(:role_samples) unless Role.where(:name => "Учет образцов").exists?
    Role.create(:name => "Учет образцов", :group => 0)
  end

  def self.down
    drop_table :samples
  end
end
