Factory.define :lk_order do |f|
  f.association :firm
  f.after_build { |order| order.lk_order_items << Factory(:lk_order_item) }
end

Factory.define :lk_order_item do |f|
  f.association :product
  f.quantity 1
  f.price 100
end

Factory.sequence :lk_firm_seq do |n|
    n 
  end
  
Factory.define :lk_firm do |f|
  f.name "Фирма #{Factory.next(:lk_firm_seq)}"
  f.contact "02"
end
