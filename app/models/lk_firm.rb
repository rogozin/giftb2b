#encoding: utf-8;
class LkFirm < ActiveRecord::Base
  has_many :commercial_offers, :dependent => :restrict
  default_scope :order => "name"
  validates :name, :presence => true
   validates :email, :email => {  :allow_blank => true},
  :length => {:maximum => 40, :allow_nil => true}  
  validates :url,
  :format => { :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix, :allow_blank => true},
  :length => {:maximum => 40, :allow_nil => true}
end
