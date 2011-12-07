#encoding: utf-8;
class CommercialOffer < ActiveRecord::Base
  has_many :commercial_offer_items, :dependent => :destroy
  has_many :lk_products, :through => :commercial_offer_items
  belongs_to :firm
  belongs_to :user
  belongs_to :lk_firm
  
  validates :sale,  :inclusion => { :in => 0..99 }
  attr_accessible :sale, :signature, :lk_firm_id
  attr_accessible :sale, :signature, :lk_firm_id, :firm_id, :user_id, :firm, :user, :as => :admin
  
  def total_price
    commercial_offer_items.map{|ci| ci.lk_product.price * ci.quantity}.sum
  end
  
  def total_price_with_sale
     total_price.to_f*((100-sale)/100.0)
  end
end
