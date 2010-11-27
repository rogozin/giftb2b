class Permalinks < ActiveRecord::Migration
  def self.up
    add_column :categories, :permalink, :string, :null => false
    Category.find(:all, :conditions => "permalink =''").each do |category|
    category.permalink = category.name.parameterize
    unless category.save  
     category.permalink = "#{category.id}-#{category.name.parameterize}"
     category.save
   end  
  end
    add_index :categories, :permalink, :unique => true
    add_column :products, :permalink, :string, :null => false
    Product.find(:all, :conditions => "permalink = ''").each do |product|
      product.permalink =  product.short_name.blank? ? product.article.parameterize : product.short_name.parameterize
      unless product.save
        product.permalink = "#{product.id}-#{ product.short_name.blank? ? product.article.parameterize : product.short_name.parameterize}"
        product.save
      end  
    end
    add_index :products,:permalink, :unique => true
  end

  def self.down
    remove_index :categories, :permalink
    remove_column :categories, :permalink
    remove_index :products, :permalink
    remove_column :products, :permalink
  end
end
