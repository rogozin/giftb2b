#encoding: utf-8;
class CommercialOfferItem < ActiveRecord::Base
  belongs_to :commercial_offer
  belongs_to :lk_product
  
  validates :quantity, :numericality => {:greater_than => 0}
  
  after_destroy :drop_lk_product
  attr_protected :commercial_offer_id
  
  private
  
  def drop_lk_product
    lk_product.destroy  if lk_product && lk_product.can_destroy?
  end
  
end
