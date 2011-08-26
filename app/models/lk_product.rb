#encoding: utf-8;
class LkProduct < ActiveRecord::Base
  has_many :commercial_offer_items
  belongs_to :product
  belongs_to :firm
  has_many :lk_product_categories
  has_many :categories, :through => :lk_product_categories
  has_attached_file :picture, :styles => {:original => "300x300", :thumb =>  "120x120"}, 
   :path =>":rails_root/public/system/firms/:firm_id/:id/:style/:filename",
   :url  => "/system/firms/:firm_id/:id/:style/:filename"
   
   scope :active, where(:active => true).order(:article)
   
   scope :search, lambda { |search_text|
    where("(short_name like :search) or (article like :search)", { :search => '%' + search_text + '%'}) }
   scope :for_my_site, lambda { |firm_id|
    active.where(:show_on_site => true, :firm_id => firm_id) }
   validates :article, :presence => true
   validates :price, :numericality => {:greater_than_or_equal_to => 0, :allow_nil => true}
   
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
   
#  before_destroy :drop_lk_product
#  
#  private 
#  def drop_lk_product
#    
#  end
end
