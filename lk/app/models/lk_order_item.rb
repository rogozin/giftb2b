#encoding: utf-8;
class LkOrderItem < ActiveRecord::Base

  belongs_to :lk_order
  belongs_to :product, :polymorphic => true
  
  def sum
    price * quantity
  end
end
