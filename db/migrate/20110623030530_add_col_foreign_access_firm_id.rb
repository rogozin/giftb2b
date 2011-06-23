class AddColForeignAccessFirmId < ActiveRecord::Migration
  def self.up
    add_column :foreign_access, :firm_id, :integer
  end

  def self.down
    remove_column :foreign_access, :firm_id
  end
end
