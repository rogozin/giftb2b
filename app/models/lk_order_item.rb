class LkOrderItem < ActiveRecord::Base

  belongs_to :lk_order
  belongs_to :product, :polymorphic => true
end
