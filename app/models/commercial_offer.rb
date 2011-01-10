class CommercialOffer < ActiveRecord::Base
  has_many :commercial_offer_items, :dependent => :delete_all
  belongs_to :firm
  belongs_to :user
end
