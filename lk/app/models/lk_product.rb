#encoding: utf-8;
class LkProduct < ActiveRecord::Base
  has_many :commercial_offer_items
  has_many :lk_order_items, :as => :product, :dependent => :restrict
  belongs_to :product
  belongs_to :firm
  has_many :lk_product_categories, :dependent => :delete_all
  has_many :categories, :through => :lk_product_categories
  has_attached_file :picture, :styles => {:original => "300x300", :thumb =>  "120x120"}, 
   :path =>":rails_root/public/system/firms/:firm_id/:id/:style/:filename",
   :url  => "/system/firms/:firm_id/:id/:style/:filename"
   
   scope :active, where(:active => true).order(:article)
   
   scope :search, lambda { |search_text|
    where("(short_name like :search) or (article like :search)", { :search => '%' + search_text + '%'}) }
   
   scope :by_category, lambda { |category_ids|
    joins(:lk_product_categories).select("distinct lk_products.*").where("lk_product_categories.category_id" => category_ids) }    
   
   scope :for_my_site, lambda { |firm_id|
    active.where(:show_on_site => true, :firm_id => firm_id) }
   
   validates :article, :presence => true
   validates :price, :numericality => {:greater_than_or_equal_to => 0, :allow_nil => false}
  attr_protected :firm_id     
   def is_my?
     product_id.nil?
   end
   
   
    def as_json(options={})
     default_options = { :only => [:id, :short_name, :color, :size, :box, :factur, :description, :store_count, :updated_at], 
     :methods=>["permalink", "pictures", "similar", "colors","properties", "unique_code", "price_in_rub" ] }
     super options.present? ? options.merge(default_options) : default_options
   end
   
   def permalink
     "lk-#{id}"
   end
   
   def pictures
     [{:orig => picture.url, :thumb => picture.url(:thumb)}] 
   end
   
   def similar
     []
   end
   
   def colors
     []
   end
   
   def properties
     [{:name => "Нанесение", :values =>  [infliction]}]
   end
   
   def unique_code
     "my-#{id}"
   end
   
   def price_in_rub
     price     
   end
   
   def can_destroy?
     lk_order_items.size == 0 && commercial_offer_items.size == 0 && !active?
   end
   
   def self.copy_from_product(product, firm_id, price=0, active=false, copy_categories=false)
       lk_product = LkProduct.new({ 
      :product_id => product.id,
      :article => product.unique_code,
      :short_name => product.short_name,
      :description => product.description,
      :price => price == 0 ? product.price_in_rub : price,
      :color => product.color, 
      :size => product.size,
      :factur => product.factur,
      :box => product.box,
      :active => active,
      :store_count => product.store_count,
      :infliction => product.property_values.select{|p| p.property.name=="Нанесение"}.map(&:value).join(' ,') })
    img = product.main_image
    begin
    if img
      File.open(img.picture.path) do  |file| 
        lk_product.picture = file
      end      
    end
    rescue
        lk_product.picture = File.open(Rails.root.to_s + "/public/images/default_image.jpg")
    end    
    lk_product.category_ids = product.category_ids if copy_categories
    lk_product.firm_id = firm_id
    lk_product.save

    lk_product
   end
   
   
#  before_destroy :drop_lk_product
#  
#  private 
#  def drop_lk_product
#    
#  end
end
