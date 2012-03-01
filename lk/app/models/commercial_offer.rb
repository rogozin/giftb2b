#encoding: utf-8;
class CommercialOffer < ActiveRecord::Base
  has_many :commercial_offer_items, :dependent => :destroy
  has_many :lk_products, :through => :commercial_offer_items
  belongs_to :firm
  belongs_to :user
  belongs_to :lk_firm
  
  validates :lk_firm_id,  :inclusion => { :in => lambda {|co| LkFirm.ids(co.firm_id)}, :allow_blank => true }  
  attr_accessible :signature, :lk_firm_id, :name
  attr_accessible :signature, :lk_firm_id, :name, :firm_id, :user_id, :firm, :user, :as => :admin
  
  def total_price
    commercial_offer_items.map{|ci| ci.lk_product.price * ci.quantity}.sum
  end
  
  def total_price_with_sale
     total_price.to_f*((100-sale)/100.0)
  end
  
  def has_sale?
    commercial_offer_items.any?{|x| x.sale > 0}
  end
  
end
