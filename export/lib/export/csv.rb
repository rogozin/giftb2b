#encoding:utf-8;
require "csv"

module Export
  class << self
    def root
       @root ||= Pathname.new(File.expand_path('../../../../', __FILE__))
    end
  end
  
  module Csv
    class << self
      cattr_accessor :directories, :base_dir
      self.base_dir = File.join(Export.root,"tmp/csvexport")
      self.directories = {:save_to => self.base_dir}

      def create_dirs
        self.directories.each_value do |dir|
          Dir.mkdir(dir) unless File.exists?(dir)
        end
      end        
    
      def export
        create_dirs
        filename = "data_out.csv"
        cnt = 0
        CSV.open(File.join(self.base_dir, filename), "w", :col_sep =>";") do |csv|
         # csv  << ["id", "name", "price", "url", "vendor", "category", "store"]
          Category.catalog.roots.each do |c|
            Product.find_all({:category=> c.id }, "categories").uniq(&:short_name).each do |product|
              csv << [product.id, product.short_name.gsub(/(\"|\n)/, ''), product.price_in_rub, "http://giftb2b.ru/products/#{product.permalink}",
              manufactor_name(product), c.name.mb_chars.capitalize.strip, product.store_count]
              cnt +=1              
            end                       
          end          
        end
        cnt
      end
      
      private
      
      def manufactor_name product
        name = ""
        name =  product.manufactor.name if product.manufactor.present? && product.manufactor.name != "no_name" && product.manufactor.name != "no-name" && product.manufactor.name != "noname"
        name
      end      
    end    
  end 
end
