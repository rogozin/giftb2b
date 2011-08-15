#encoding: utf-8;
class Product < ActiveRecord::Base
  has_many :product_categories, :dependent => :delete_all
  has_many :categories, :through => :product_categories
  has_many :analog_categories, :through => :product_categories, :source => :category, :conditions => "categories.kind=3"
  has_many :main_categories, :through => :product_categories, :source => :category, :conditions => "categories.kind=1"  
  belongs_to :manufactor
  belongs_to :supplier
  has_many :attach_images, :as => :attachable, :dependent => :delete_all, :foreign_key => :attachable_id, :order => "main_img desc"
  has_many :images, :through => :attach_images
  has_many :product_properties, :class_name=>"ProductProperty", :dependent => :delete_all
  has_many :property_values, :through => :product_properties, :include => :property, :select => "property_values.*, properties.name property_name", :order => "value"

  has_many :card_properties,  :through => :product_properties, :source => :property_value, :include => :property,  :conditions => "properties.active=1 and properties.show_in_card=1 and properties.property_type = 0", :order => "properties.sort_order"

  has_many :text_properties,  :through => :product_properties, :source => :property_value, :include => :property,  :conditions => "properties.active=1  and properties.property_type = 0", :order => "properties.sort_order"

  has_many :image_properties,  :through => :product_properties, :source => :property_value, :include => :property, :conditions => "properties.active=1 and properties.show_in_card=1 and properties.property_type = 3"
  

  scope :for_admin, joins([:supplier,:manufactor,  ", (select usd,eur from currency_values v order by id desc limit 1) c" ]).select("distinct products.*, manufactors.name manufactor_name, suppliers.name supplier_name,  case products.currency_type when 'USD' then c.usd * products.price when 'EUR' then c.eur * products.price else products.price end ruprice").order("sort_order, ruprice")
 
  scope :search, lambda { |search_text|
  active.where("(products.short_name like :search) or (lpad(products.id,6,'0')=:code)", { :search => '%' + search_text + '%',:code => search_text}) }
  
  scope :search_with_article, lambda { |search_text|
  active.where("(products.short_name like :search) or (lpad(products.id,6,'0')=:code) or products.article like :search", 
  {:search =>  '%' + search_text + '%', :code =>search_text}) } 

  scope :novelty, where({:is_new => true})
  scope :sale, where({:is_sale => true})
  scope :active, where({:active => true})
  scope :all_by_category, lambda { |category_ids|
    joins(:product_categories).where("product_categories.category_id" => category_ids)
  }
  validates :supplier_id, :presence => true
  validates :article, :presence => true
  validates_uniqueness_of :permalink, :allow_nil => true
  
  before_save :set_permalink  
  after_save :clear_cache

  def self.cached_novelty
    Rails.cache.fetch('novelty', :expires_in =>1.hours) { novelty}
  end
  
  def self.find_all(options={}, place= "admin")
    sr = Product.scoped
    options[:per_page] ||=20
    if options[:category] 
      if  options[:category].to_i >0
        cat = Category.find(options[:category].to_i)
        cats_arr = Category.tree_childs(Category.cached_all_categories,cat)
        sr =sr.where("exists (select null from product_categories ps where ps.product_id = products.id and  ps.category_id in ( :category))", :category => cats_arr || options[:category])
     elsif options[:category].to_i ==-1
        sr = sr.where("not exists (select null from product_categories ps where ps.product_id = products.id)")
      end
    end 

    sr = sr.where(:manufactor_id => options[:manufactor]) if options[:manufactor].present? && options[:manufactor].to_i >0 
    
    sr = sr.where(:supplier_id => options[:supplier]) if options[:supplier].present? && options[:supplier].to_i > 0
  
    sr = sr.where("products.article like :name", :name => '%'+options[:name]+'%') unless options[:name].blank? 

    sr = sr.where("products.short_name like :search_text or description like :search_text", :search_text => '%'+options[:search_text]+'%' )  unless options[:search_text].blank? 
    
    sr = sr.where("lpad(products.id,6,'0') = :code", :code => options[:code])      unless options[:code].blank? 
    
    sr = sr.where("products.active" => options[:active] == "0" ? false : true) unless options[:active].blank?
    
    sr = sr.where(:is_new => options[:new] =="0" ? false : true) if options[:new].present?
        
    sr = sr.where(:sale => options[:sale] == "0" ? false : true) if options[:sale].present?
    
    sr = sr.where(:best_price => options[:best_price] == "0" ? false : true) if options[:best_price].present?
    
    sr = sr.where("products.price" => 0) if options[:price] && options[:price]=="0"

    sr = sr.where("products.price > 0") if options[:price] && options[:price]=="1"

    sr = sr.where("products.store_count" => 0) if options[:store] && options[:store]=="0"
    
    sr = sr.where("products.store_count >0") if options[:store] && options[:store]=="1"
    
    
  
    prop_keys = options.keys.select{|x| x =~ /property_values_/}
    sr = sr.where(prop_keys.map{|x| "(exists (select null from product_properties pp where pp.product_id = products.id and pp.property_value_id in (#{options[x].join(',')})) ) " }.join(" AND ")) if prop_keys.present?

    res= case place
      when "xml"
        sr.for_admin
      when "json"
        sr.active
      else
        sr.for_admin.paginate(:page=>options[:page], :per_page=>options[:per_page])
      end

  end
  
  
  def unit
    case self.currency_type
      when 'RUB' 
        'руб.'
      when 'USD'
        '$'
      when 'EUR'
        '&euro'
    else 'у.е.'      
    end
  end
   
   def price_in_rub
     (CurrencyValue.kurs(currency_type)* price).round(2)
   rescue
     0
   end
     
   def to_param
     self.permalink
   end
   
   def as_json(options={})
     default_options = { :only => [:id, :short_name, :permalink, :color, :size, :box, :factur, :description, :store_count, :updated_at], 
     :methods=>[ "pictures", "similar", "colors","properties", "unique_code", "price_in_rub" ] }
     super options.present? ? options.merge(default_options) : default_options
   end
   
   #########################
   ##API 
   
  def pictures 
     res =  cached_attached_images.map do |attached_image|
       {:orig => attached_image.image.picture.url, :thumb => attached_image.image.picture.url(:thumb)}
     end
     res = [{:orig => Image.default_image, :thumb => Image.default_image}] if res.empty?
     res
  end

  def similar
    cached_analogs(4).map do |analog|
      { :permalink => analog.permalink, 
        :thumb => 
          analog.cached_attached_images.present? ? analog.cached_attached_images.first.image.picture.url(:thumb) : Image.default_image,
        :short_name => analog.short_name
      }
    end                    
  end

  def colors
    cached_color_variants.map do |property_name, products|
         { :property_name =>property_name, :products => products.map{|p| {:permalink => p.permalink, 
           :thumb => p.cached_attached_images.present? ? p.cached_attached_images.first.image.picture.url(:thumb) : Image.default_image,
           :short_name =>  p.short_name } } 
         } 
    end
  end
  
  def properties
     cached_properties
  end

   def cached_analogs(limit=0)
     Rails.cache.fetch("product_#{self[:id]}.analogs_#{limit}", :expires_in =>1.hour){ analogs(limit).all }
   end
   
  def cached_attached_images
    Rails.cache.fetch("product_#{self[:id]}.attached_images", :expires_in =>1.hour){ attach_images.all }
  end
  
  def cached_images
    Rails.cache.fetch("product_#{self[:id]}.images", :expires_in =>1.hour){ images.all }
  end

  def cached_color_variants
    Rails.cache.fetch("product_#{self[:id]}.color_variants", :expires_in =>1.hour){ color_variants }    
  end
  
  def cached_properties
    Rails.cache.fetch("product_#{self[:id]}.properties", :expires_in =>1.hour){ additional_properties }    
  end  

   
   ########################

   def update_permalink
     self.permalink = prepare_permalink
   end 
   
   def update_permalink!
     update_attribute(:permalink,prepare_permalink )    
   end
   
   def unique_code
    ind = self.id.blank? ? Product.maximum(:id)+1 : id
    ind.to_s.rjust(6,'0')
   end

   
   def main_image
      main_img = cached_attached_images.select{|x|x.main_img}.first
      main_img ? main_img.image : cached_images.first
   end
  
  def picture
    main_image.picture if main_image
  end


   def analogs(limit=0)
    analogs = Product.joins(:categories).where("categories.id in (:category_ids) and product_id <> :product_id",
                                               {:category_ids => main_categories.map{|x| x[:id]}, :product_id => self[:id]}).order("rand()")
    analogs = analogs.limit(limit) if limit >0
    analogs
   end
  
  def additional_properties
    res = []
    card_properties.group_by{|x| x.property.name}.each do |property_name, property_values|
      res << {:name => property_name, :values =>  property_values.map{|x| x.value}}
    end
    res
  end
  
  def color_variants
    res = {}
    image_properties.group_by{|x| x.property.name}.each do |property_name, property_values| 
       res.merge!( property_name =>   property_values.map{|val| Product.find_by_article(val.value)}.delete_if{|item| item.nil?} )
    end 
    res
  end


  
  private
    
  def set_permalink
    if self.permalink.blank? 
      self.permalink = prepare_permalink
    else 
      self.permalink= self.permalink.parameterize
    end
  end
   
   def prepare_permalink
     Product.exists?(:permalink =>self.short_name.parameterize) ? "#{self.unique_code}-#{self.short_name.parameterize}" : self.short_name.parameterize
   end
   
  def clear_cache
    Rails.cache.delete('novelty')
  end  
   
end

