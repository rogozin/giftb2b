module Lk::CommercialOffersHelper
  
  def price_with_sale price, sale
    price - price*(sale.to_f/100)
  end
end
