class CreateManufactors < ActiveRecord::Migration
  def self.up
    create_table :manufactors do |t|
      t.string :name, :limit => 80
      t.timestamps
    end
  end

  def self.down
    drop_table :manufactors
  end
end
