class CreateForeignAccesses < ActiveRecord::Migration
  def self.up
    create_table :foreign_access do |t|
      t.string :name, :size => 30
      t.string :ip_addr, :size => 15
      t.string :param_key, :size => 15
      t.datetime :accepted_from
      t.datetime :accepted_to
      t.timestamps
    end
  end

  def self.down
    drop_table :foreign_access
  end
end
