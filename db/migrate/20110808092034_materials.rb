#encoding:utf-8;
class Materials < ActiveRecord::Migration
  def self.up
#    original_prop = Property.find(7)
#    sort_prop = Property.find_or_create_by_name("Материалы упорядоченные")
#    sort_prop.sort_order =0
#    sort_prop.for_all_products = true
#    sort_prop.for_search = true
#    sort_prop.save
#    
#    #Удаляем свойства, помеченные как удалить.
#    original_prop.property_values.where(:note => "удалить").each{|x| x.destroy}
#    
#    #добавляем новые свойства
#    original_prop.property_values.map{|x| x.note.present? ? x.note : nil}.uniq.compact.each do |value|
#      sort_prop.property_values.create(:value => value)
#    end
#    
#    sort_prop.property_values.each do |value|
#      puts "===#{value.value}"
#      original_prop.property_values.where(:note => value.value).each do |oprop|
#        puts "====original prop=#{oprop.value}"
#        oprop.products.each do |product|
#          begin
#            product.product_properties.create(:property_value => value)
#          rescue
#            puts "ошибка добавления св-ва: #{value.value}"
#          end
#        end
#        oprop.destroy
#      end
#    end
#    
#    
#    original_colors = Property.find(8)
#    sort_colors = Property.find_or_create_by_name("Цвета упорядоченные")
#    sort_colors.sort_order =0
#    sort_colors.for_all_products = true
#    sort_colors.for_search = true
#    sort_colors.save
#    
#    #добавляем новые свойства
##    original_colors.property_values.map{|x| x.note ? x.note.split(';') : nil}.flatten.compact.uniq.each do |value|
##      sort_colors.property_values.create(:value => value)
##    end


#    sort_colors.property_values.each do |value|
#      original_colors.property_values.where("note like '%#{value.value}%'").each do |oprop|
#        oprop.products.each do |product|
#          begin
#            product.product_properties.create(:property_value => value)
#          rescue
#            puts "ошибка добавления св-ва: #{value.value}"
#          end
#        end
#        oprop.destroy
#      end
#    end

    
  end

  def self.down
  end
end
