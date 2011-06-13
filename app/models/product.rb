class Product < ActiveRecord::Base
  has_many :product_categories, :dependent => :delete_all
  has_many :categories, :through => :product_categories
  has_many :analog_categories, :through => :product_categories, :source => :category, :conditions => "categories.kind=3"
  has_many :main_categories, :through => :product_categories, :source => :category, :conditions => "categories.kind=1"  
  belongs_to :manufactor
  belongs_to :supplier
  has_many :attach_images, :as => :attachable, :dependent => :delete_all, :foreign_key => :attachable_id
  has_many :images, :through => :attach_images
  has_many :product_properties, :class_name=>"ProductProperty", :dependent => :delete_all
  has_many :property_values, :through => :product_properties, :select => "property_values.*, properties.name property_name"
  has_many :text_properties,  :through => :product_properties, :source => :property_value, :select => "property_values.*, properties.name property_name, properties.property_type property_type", :conditions => "properties.active=1 and properties.property_type = 0"
  has_many :image_properties,  :through => :product_properties, :source => :property_value, :select => "property_values.*, properties.name property_name", :conditions => "properties.active=1 and properties.property_type = 3"
  

  scope :for_admin, joins([:supplier,:manufactor, ", (select usd,eur from currency_values v order by id desc limit 1) c" ]).select("distinct products.*, manufactors.name manufactor_name, suppliers.name supplier_name,  case products.currency_type when 'USD' then c.usd * products.price when 'EUR' then c.eur * products.price else products.price end ruprice").order("sort_order, ruprice")
 
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
    options[:per_page] ||=20
    cond=[[],{}]
    if options[:category] 
      if  options[:category].to_i >0
        cat = Category.find(options[:category].to_i)
        cats_arr = Category.tree_childs(Category.cached_all_categories,cat)
        cond[0]<<  "exists (select null from product_categories ps where ps.product_id = products.id and  ps.category_id in ( :category))"
        cond[1][:category]=cats_arr || options[:category]
     elsif options[:category].to_i ==-1
        cond[0]<<  "not exists (select null from product_categories ps where ps.product_id = products.id)"
      end
    end 
    if options[:manufactor].present? && options[:manufactor].to_i >0
      cond[0]<<  "manufactor_id=:manufactor"
      cond[1][:manufactor]=options[:manufactor]
    end  
    if options[:supplier].present? && options[:supplier].to_i
      cond[0]<<  "supplier_id=:supplier"
      cond[1][:supplier]=options[:supplier]
    end      
    cond[0]<<  "products.active=#{options[:active]}"    unless options[:active].blank?
    unless options[:name].blank? 
      cond[0]<< "products.article like :name"
      cond[1][:name]= '%'+options[:name]+'%'
    end
    unless options[:search_text].blank? 
      cond[0]<< "products.short_name like :search_text or description like :search_text"
      cond[1][:search_text]= '%'+options[:search_text]+'%'
    end  
    unless options[:code].blank? 
      cond[0]<< "lpad(products.id,6,'0') = :code"
      cond[1][:code]= options[:code]
    end 
    unless options[:new].blank?
      cond[0]<< "products.is_new = :new " 
      cond[1][:new] = options[:new]
    end
    unless options[:sale].blank?
      cond[0]<< "products.is_sale = :sale " 
      cond[1][:sale] = options[:sale]
    end    
    unless options[:best_price].blank?
      cond[0]<< "products.best_price = :best_price " 
      cond[1][:best_price] = options[:best_price]
    end    
    cond[0]<< "products.price =0"    if options[:price] && options[:price]=="0"
    cond[0]<< "products.price >0"    if options[:price] && options[:price]=="1"
    cond[0]<< "products.store_count=0"    if options[:store] && options[:store]=="0"
    cond[0]<< "products.store_count >0"    if options[:store] && options[:store]=="1"        
    total_conditions = cond[0] && cond[0].size>0 ? [cond[0].join(" AND "), cond[1]]  : []
    res= case place
      when "xml"
        for_admin.all(:conditions=>total_conditions)
      when "json"
        active.where(total_conditions)
      else
        for_admin.paginate(:all,:page=>options[:page], :per_page=>options[:per_page], :conditions=>total_conditions)
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
     CurrencyValue.kurs(currency_type)* price
   rescue
     0
   end
   


   def analogs(limit=0)
    analogs = Product.joins(:categories).where("categories.id in (:category_ids) and product_id <> :product_id", {:category_ids => analog_categories.map(&:id), :product_id => id})
    analogs = analogs.limit(limit) if limit >0
    analogs
   end
   
   def to_param
     self.permalink
   end
   
   def as_json(options={})
     default_options = {:only => [:id, :short_name, :permalink, :color, :size, :box, :factur, :description, :store_count], 
     :methods=>[:unique_code, :image_thumb, :image_orig, :price_in_rub]}
     super options.present? ? options.merge(default_options) : default_options
   end
   
   #########################
   ##API 
   
  def image_thumb
    picture ? picture.url(:thumb) : "images/default_image.jpg"
  end
  
  def image_orig
    picture ? picture.url : ""
  end
   
   ########################

   def update_permalink
     self.permalink = prepare_permalink
   end 
   
   def update_permalink!
     update_attribute(:permalink,prepare_permalink )    
   end
   
   def unique_code
    ind = self.id.blank? ? Product.maximum(:id)+1 : self.id
    ind.to_s.rjust(6,'0')
   end

   
   def main_image
      main_img = cached_attached_images.select{|x|x.main_img}.first
      main_img ? main_img.image : cached_images.first
   end
  
  def picture
    main_image.picture if main_image
  end
  
  
  
  private
  
  def cached_attached_images
    Rails.cache.fetch("product_#{self.id}.attached_images", :expires_in =>1.hour){ attach_images }
  end
  
  def cached_images
    Rails.cache.fetch("product_#{self.id}.images", :expires_in =>1.hour){ images }
  end
  
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

