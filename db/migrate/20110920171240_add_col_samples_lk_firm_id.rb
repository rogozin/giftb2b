class AddColSamplesLkFirmId < ActiveRecord::Migration
  def self.up
    add_column :samples, :lk_firm_id, :integer
    Sample.update_all "lk_firm_id = firm_id"
    Sample.update_all "firm_id = 2"
  end

  def self.down
    Sample.update_all "firm_id = lk_firm_id"
    remove_column :samples, :lk_firm_id
  end
end
