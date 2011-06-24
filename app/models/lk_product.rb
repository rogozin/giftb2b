#encoding: utf-8;
class LkProduct < ActiveRecord::Base
  has_many :commercial_offer_items
  belongs_to :product
  has_attached_file :picture, :styles => {:original => "120x120"}, 
   :path =>":rails_root/public/system/firms/:firm_id/:id/:style/:filename",
   :url  => "/system/firms/:firm_id/:id/:style/:filename"
   
   scope :active, where(:active => true).order(:article)
   scope :search, lambda { |search_text|
  where("(short_name like :search) or (article like :search)", { :search => '%' + search_text + '%'}) }
   validates :article, :presence => true
   validates :price, :numericality => {:greater_than_or_equal_to => 0, :allow_nil => true}
   
#  before_destroy :drop_lk_product
#  
#  private 
#  def drop_lk_product
#    
#  end
end
