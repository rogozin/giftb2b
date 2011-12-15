#encoding: utf-8;
class CommercialOfferItem < ActiveRecord::Base
  belongs_to :commercial_offer
  belongs_to :lk_product
  
  validates :quantity, :numericality => {:greater_than => 0}
  validates :sale,  :inclusion => { :in => 0..99 }
  after_destroy :drop_lk_product
  
  private
  
  def drop_lk_product
    lk_product.destroy  if lk_product && lk_product.can_destroy?
  end
  
end
