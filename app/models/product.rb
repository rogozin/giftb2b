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
  

  scope :for_admin, :joins=>[:supplier,:manufactor], :select =>"distinct products.*, manufactors.name manufactor_name, suppliers.name supplier_name"
  
  scope :search, lambda { |search_text|
  {:conditions => ["(products.short_name like ?) or (lpad(products.id,6,'0')=?)",  '%' + search_text + '%', search_text], :limit => 50} }
  
  validates_presence_of  :supplier_id, :article
  validates_uniqueness_of :permalink, :allow_nil => true
  
  before_save :set_permalink  
  

  def self.filter_data_by_category(category=0, manufactor=0) 
     cond=[[],{}]
     if category>0
       cat = Category.cached_all_categories.select{|c| c.id==category.to_i}
       cats_arr = Category.tree_childs(Category.cached_all_categories,cat) 
       cond[0]<<  "category_id in ( :category)"
       cond[1][:category]=cats_arr || category
    end
    if manufactor>0
       cond[0]<<  "manufactor_id = ( :manufactor)"
       cond[1][:manufactor]=manufactor
    end
     total_conditions = cond[0] && cond[0].size>0 ? [cond[0].join(" AND "), cond[1]]  : []
     find(:all, :joins=>[:category, :manufactor], :select=>"category_id, categories.name category_name, manufactor_id, manufactors.name manufactor_name", :conditions=>total_conditions) 
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
    if !options[:manufactor].blank? && options[:manufactor].to_i >0
      cond[0]<<  "manufactor_id=:manufactor"
      cond[1][:manufactor]=options[:manufactor]
    end  
    if !options[:supplier].blank? && options[:supplier].to_i >0
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
    cond[0]<< "products.price =0"    if options[:price] && options[:price]=="0"
    cond[0]<< "products.price >0"    if options[:price] && options[:price]=="1"
    cond[0]<< "products.store_count=0"    if options[:store] && options[:store]=="0"
    cond[0]<< "products.store_count >0"    if options[:store] && options[:store]=="1"        
    total_conditions = cond[0] && cond[0].size>0 ? [cond[0].join(" AND "), cond[1]]  : []
    puts total_conditions
    res= if place=="xml"
      for_admin.all(:conditions=>total_conditions)
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
     Product.find(:all, :joins=>:categories, :conditions => ["categories.id in (?) and products.id <> ?",self.analog_category_ids,self.id],:limit=>(limit == 0 ? nil : limit))
   end
   
   def to_param
     self.permalink
   end

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
      main_img = attach_images.find_by_main_img(true)
      main_img ? main_img.image : images.first
   end
  
  def picture
    main_image.picture if main_image
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
   
end

