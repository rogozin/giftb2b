class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.integer :firm_id, :null => false
      t.integer :state_id, :default => 0
      t.string :title
      t.text :body
      t.text :permalink
      t.string  :picture_file_name
      t.string  :picture_content_type
      t.integer :picture_file_size    
      t.datetime :picture_updated_at
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end
  end
end
