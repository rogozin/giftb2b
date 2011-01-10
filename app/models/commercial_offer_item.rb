class CommercialOfferItem < ActiveRecord::Base
  belongs_to :commercial_offer
  belongs_to :product
end
