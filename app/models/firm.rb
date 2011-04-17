class Firm < ActiveRecord::Base
  has_many :attach_images, :as => :attachable, :dependent => :destroy, :foreign_key => :attachable_id
  has_many :images, :through => :attach_images
  validates :name, :presence => true, :uniqueness => true
  validates :email,
  :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :allow_blank => true},
  :length => {:maximum => 40, :allow_nil => true}  
  validates :url,
  :format => { :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix, :allow_blank => true},
  :length => {:maximum => 40, :allow_nil => true}
  
 def logo
   images.first.picture.url if images.present?
 end
 
 #Return Paperclip::Geometry instance
 def logo_geometry
   Paperclip::Geometry.from_file(images.first.picture.path) if images.present?
 end
  
end
