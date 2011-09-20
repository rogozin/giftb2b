class CreateBanners < ActiveRecord::Migration
  def self.up
    create_table :banners do |t|
      t.integer :firm_id, :null => false
      t.integer :type_id, :default => 0
      t.text :text
      t.boolean :active, :default => false
#      t.string :phone_prefix
#      t.string :phone
      t.string :url
      t.integer :show_cnt
      t.integer :go_cnt
      t.timestamps
    end
  end

  def self.down
    drop_table :banners
  end
end
