#encoding: utf-8;
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
  f.email "lk_firm@example.com"
end

Factory.define :commercial_offer do |f|
  f.association :firm
  f.association :lk_firm
  f.sale 10
  f.email "demo@giftb2b.ru"
  f.signature "Всего хорошего!"
  f.association :user
  f.after_create { |co| co.commercial_offer_items.create(:quantity => 10, :lk_product => Factory(:lk_product, :firm_id => co.firm_id, :article => "#{co.id}-aaa")) }
end 


Factory.define :lk_product do |f|
  f.association :firm
  f.article "12345"
  f.short_name "наш сувенир"
  f.price 123
  f.active true
  f.store_count 10
end
