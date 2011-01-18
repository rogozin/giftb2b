class LkProduct < ActiveRecord::Base
  has_attached_file :picture, :styles => {:original => "120x120"}, 
   :path =>":rails_root/public/system/firms/:firm_id/:id/:style/:filename",
   :url  => "/system/firms/:firm_id/:id/:style/:filename"
   
   validates :article, :presence => true
     validates :price, :numericality => {:greater_than_or_equal_to => 0, :allow_nil => true}
end
