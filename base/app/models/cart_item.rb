#encoding: utf-8;
class CartItem
  attr_reader :product, :quantity,:sale,:start_price
  
  def initialize(product)
    @product=product
    @start_price=product.price_in_rub
    @quantity=1
    @sale=0
  end
  
  attr_reader :referer, :product
  
  def increment_quantity
    @quantity += 1
  end
  
  def quantity= (val=1)
    @quantity= val if val>=0 && val < 10000
  end
  
  def sale= (val=0)
    @sale= val if val>=0 && val < 100
  end
  
  def start_price= (val=0)
    @start_price= val if val>=0 
  end
    
  def price
    @start_price*@quantity*(1-@sale/100.to_f)
  end
end
