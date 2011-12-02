module Lk::CommercialOffersHelper
  
  def price_with_sale price, sale
    price - sale_size(price, sale)
  end
  
  def sale_size price, sale
    price*(sale.to_f/100)
  end
end
