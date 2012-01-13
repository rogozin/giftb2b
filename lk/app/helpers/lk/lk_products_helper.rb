module Lk::LkProductsHelper
  
  def lk_article lk_product
    lk_product.is_my? ? lk_product.article  : content_tag(:span, lk_product.product.unique_code, :class => "art-product") + content_tag(:span, " (#{lk_product.product.article})", :class => "art-sup")
  end
  
  
  def product_image_link lk_product
    link_to_if lk_product.product, image_tag(lk_product && lk_product.picture ? lk_product.picture.url(:thumb) : "default_image.jpg"), main_app.product_path(lk_product.product), :target => "_blank"
  end
  
end
