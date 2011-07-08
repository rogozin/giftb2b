class AddColSamplesResponsibleId < ActiveRecord::Migration
  def self.up
    add_column :samples, :responsible_id, :integer
  end

  def self.down
    remove_column :samples, :responsible_id
  end
end
