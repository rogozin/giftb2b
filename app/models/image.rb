class Image < ActiveRecord::Base
   has_many :attach_images, :dependent => :delete_all
   has_attached_file :picture, :styles => {:thumb => "120x120" }
   
   def self.default_image
     "images/default_image.jpg"
   end
end


