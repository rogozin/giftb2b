#encoding: utf-8;
class Firm < ActiveRecord::Base
  has_many :attach_images, :as => :attachable, :dependent => :destroy, :foreign_key => :attachable_id
  has_many :images, :through => :attach_images
  has_many :users
  validates :name, :presence => true, :uniqueness => true
  validates :email, :email => {:allow_blank => true},  :length => {:maximum => 40, :allow_nil => true}  
  validates :permalink, :presence => true, :uniqueness => true
  validates :url,
  :format => { :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix, :allow_blank => true},
  :length => {:maximum => 40, :allow_nil => true}
  
  validates :lat, :inclusion => { :in => -90..90, :allow_nil => true }
  validates :long, :inclusion => { :in => -180..180, :allow_nil => true }
  scope :clients, where(:is_supplier => false)
  scope :default_city, clients.where("upper(city) = 'МОСКВА'")
  scope :where_city_present, clients.where("length(city) > 0").order("city")
  before_validation :set_permalink
  
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

private 

   def set_permalink
    self[:permalink] = (short_name || name).parameterize  unless self[:permalink]
  end
  
end
