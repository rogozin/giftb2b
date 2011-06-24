#encoding: utf-8;
class CommercialOfferItem < ActiveRecord::Base
  belongs_to :commercial_offer
  belongs_to :lk_product
  
  validates :quantity, :numericality => {:greater_than => 0}
  
  before_destroy :drop_lk_product
  
  private
  def drop_lk_product
    lk_product.destroy  if lk_product && !lk_product.active? && lk_product.commercial_offer_items.size ==1          
  end
  
end
