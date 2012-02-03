class ConvertCategoryTextileToHtml < ActiveRecord::Migration
  def up
   Category.all.each{|c| c.update_attribute :description, RedCloth.new(c.description).to_html if c.description.present? }
  end

  def down
  end
end
