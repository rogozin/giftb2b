#encoding: utf-8;
class Firm < ActiveRecord::Base
  has_many :attach_images, :as => :attachable, :conditions => {:attachable_type =>"Firm"}, :dependent => :destroy, :foreign_key => :attachable_id
  has_many :images, :through => :attach_images
  has_many :firm_services, :dependent => :delete_all
  has_many :services, :through => :firm_services, :conditions => "deleted_at is null"
  has_many :archived_services, :through => :firm_services, :conditions => "deleted_at is not null", :source => "service"
  has_many :users
  has_many :commercial_offers, :class_name => "::Lk::CommercialOffer"
  has_many :lk_orders , :class_name => "LkOrder"  
  has_many :lk_firms , :class_name => "LkFirm"    
  has_many :lk_products , :class_name => "LkProduct"      
  has_many :samples , :class_name => "Sample"        
  has_one :client
  belongs_to :supplier  
  validates :name, :presence => true, :uniqueness => true
  validates :email, :email => {:allow_blank => true},  :length => {:maximum => 40, :allow_nil => true}  
  validates :permalink, :presence => true, :uniqueness => true
  validates :phone, :presence => true
    
#  validates :url,
#  :format => { :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix, :allow_blank => true},
#  :length => {:maximum => 40, :allow_nil => true}
#  
  validates :lat, :inclusion => { :in => -90..90, :allow_nil => true }
  validates :long, :inclusion => { :in => -180..180, :allow_nil => true }
  scope :clients, where("supplier_id is null")
  scope :default_city, clients.where("upper(city) = 'МОСКВА'")
  scope :where_city_present, clients.where(:show_on_site => true).where("length(city) > 0").order("city")
  before_validation :set_permalink
  after_create :set_default_logo
  
 attr_accessible :name, :addr_f, :description, :as => :supplier
 attr_accessible :name, :short_name, :addr_f, :addr_f, :phone, :email, :supplier_id, :city, :subway, :show_on_site, :url, :description, :permalink, :lat, :long, :as => :admin
 attr_accessible :name, :phone, :email, :city, :url, :permalink, :as => :register

 def smart_name 
   short_name.presence || name
 end
  
 def logo
   images.first.picture if images.present?
 end

 def foreign_access
   ForeignAccess.accepted_clients.select{|x| x.firm_id == self.id }
 end

  def has_foreign_access?
    foreign_access.present?
  end
   
 #Return Paperclip::Geometry instance
 def logo_geometry
   Paperclip::Geometry.from_file(images.first.picture.path) if images.present?
 end
 
  def commit_service(service)
    users.each do |user|
      user.role_object_ids = (user.role_object_ids + service.role_ids).uniq
    end
  end

  def rollback_service(service)
    other_service_ids = service_ids - [service.id]
    other_role_ids = ServiceRole.where(:service_id => other_service_ids).map(&:role_id).uniq
    users.each do |user|
      user.role_object_ids = other_role_ids
    end  
  end

private 

   def set_permalink
    self[:permalink] = (short_name || name).parameterize  unless self[:permalink].present?
  end
  
  def set_default_logo
     f= File.open(File.join(Core::Engine.root, "/public/images/logo-default.jpg"))
     images = Image.where(:picture_file_name => "logo-default.jpg", :picture_file_size => f.size)
     img = images.present? ? images.first :  Image.create(:picture => f)
     AttachImage.create(:attachable => self, :image => img)
     f.close
  end
  
  
end
