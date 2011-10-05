class LkProductCategory < ActiveRecord::Base
  belongs_to :lk_product
  belongs_to :category
  set_primary_keys :lk_product_id, :category_id
end
