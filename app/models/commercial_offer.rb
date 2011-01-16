class CommercialOffer < ActiveRecord::Base
  has_many :commercial_offer_items, :dependent => :delete_all
  belongs_to :firm
  belongs_to :user
  belongs_to :lk_firm
  
  validates :sale,  :inclusion => { :in => 0..99 }
  
  def total_price
    commercial_offer_items.sum("price * quantity")
  end
  
  def total_price_with_sale
     total_price.to_f*((100-sale)/100.0)
  end
end
