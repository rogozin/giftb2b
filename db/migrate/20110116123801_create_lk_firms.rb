class CreateLkFirms < ActiveRecord::Migration
  def self.up
    create_table :lk_firms do |t|
      t.integer :firm_id
      t.string :name
      t.string :contact
      t.text :addr_u
      t.text :addr_f
      t.text :description
      t.string :phone, :size => 100
      t.string :email, :size => 40
      t.string :url, :size => 40
      t.timestamps
    end
  end

  def self.down
    drop_table :lk_firms
  end
end
