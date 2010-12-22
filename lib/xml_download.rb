#require 'nokogiri'
require 'open-uri'

module XmlDownload

 class << self
 
  
  def get_xml(products, options={})
  options ||={}
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.channel {
        products.each do |product|
        xml.item {
            xml.product_sku product.article
            xml.brand_name product.supplier_name
            xml.manufacturer_name product.manufactor_name
            xml.category_path {xml.cdata decode_categories(product)}
            xml.product_name { xml.cdata product.short_name }
            xml.product_desc { xml.cdata product.description } if options.key? :description
            xml.product_material { xml.cdata product.factur } if options.key? :factur
            xml.product_size { xml.cdata product.size } if options.key? :size
            xml.product_color { xml.cdata product.color } if options.key? :color
            xml.product_box { xml.cdata product.box } if options.key? :box
            xml.product_price product.price if options.key? :price
            xml.product_currency product.currency_type if options.key? :price
            xml.product_stock product.from_store ? 1:0 if options.key? :store
            xml.product_in_stock product.store_count  if options.key? :store
            xml.meta_description { xml.cdata product.meta_description } if options.key? :meta
            xml.meta_keywords { xml.cdata product.meta_keywords }    if options.key? :meta
            if product.images and options.key? :images
               xml.product_full_image {
                 product.images.each do |image|
                  xml.image image.picture.url
                 end                 
               }

            end
            
            if product.text_properties and options.key? :additional_properties
            xml.additional_properties {
              product.text_properties.group_by(&:property_name).each do |property_name, property_values|
                xml.property {
                  xml.type_ 0
                  xml.name {xml.cdata property_name}
                  property_values.each do |pv|
                  xml.values{
                    xml.value {xml.cdata pv.value}
                  }                  
                  end
                }
              end
            }
            end
        }
        end
      }
    end
    builder.to_xml
  end
  
  def save_to_file
    f=File.new(File.join(Rails.root,'xml_download.xml'),'w')
    f<< get_xml
    f.close
  end
  
  def decode_categories(product)
    @categories ||= Category.all
    product.categories.map{|c| c.kind.to_s + "/" + Category.tree_nesting_by_name(@categories, c).reverse.join("/")}.join('|')
  end
  
 end
 
end
