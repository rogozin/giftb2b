class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name, :null => false
      t.string :code, :null => false      
      t.integer :type_id, :default => 0      
      t.integer :price, :default => 0      
      t.datetime :date_from
      t.datetime :date_to
      t.timestamps
    end
    add_index :services, :code, :unique => true
  end
end
