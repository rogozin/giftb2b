class CommercialOfferItem < ActiveRecord::Base
  belongs_to :commercial_offer
  belongs_to :product
  
 validates :quantity, :numericality => {:greater_than => 0}
  validates :price, :numericality => {:greater_than => 0}
  
end
