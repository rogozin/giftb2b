class AddColFirmShowOnSite < ActiveRecord::Migration
  def self.up
    add_column :firms, :show_on_site, :boolean, :default => false
  end

  def self.down
    remove_column :firms, :show_on_site
  end
end
