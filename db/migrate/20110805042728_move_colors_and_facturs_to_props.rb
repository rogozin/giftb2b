#encoding:utf-8
class MoveColorsAndFactursToProps < ActiveRecord::Migration
  def self.up
    materials = Property.create(:name => "Материал", :sort_order => 0, :for_all_products => true, :for_search => true, :type => 0)
    colors = Property.create(:name => "Цвет", :sort_order => 0, :for_all_products => true, :for_search => true, :type => 0)
    Product.where("factur is not null").map(&:factur).uniq.compact.map{|x|x.split('/').map{|xx| xx.mb_chars.capitalize.to_s}}.flatten.uniq.each do |factur|
      materials.property_values.create(:value => factur)
    end
    Product.where("color is not null").map(&:color).uniq.each do |color|
      colors.property_values.create(:value => color)
    end    
    
    
    Product.all.each do |product|
      if product.factur.present?
        product.factur.split('/').map{|xx| xx.mb_chars.capitalize.to_s}.each do |factur|
          mat = materials.property_values.where(:value => factur).first
          product.product_properties.create(:property_value => mat) if mat
        end
      end
      
      if product.color.present?
          color = colors.property_values.where(:value => product.color).first
          product.product_properties.create(:property_value => color) if color
      end      
    end
    
  end

  def self.down
  end
end
