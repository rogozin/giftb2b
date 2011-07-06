#encoding: utf-8;
Factory.sequence :sample_seq do |n|
  "Образец №#{n}"
end

Factory.define :sample do |f|
  f.name {Factory.next(:sample_seq) }
  f.association :supplier
  f.association :firm 
  f.buy_price 100 
  f.sale_price 150
  f.buy_date { Date.yesterday }
  f.sale_date { Date.today }
  f.supplier_return_date { Date.today + 3.days }
  f.client_return_date { Date.tomorrow }
  f.association :user, :factory => :sample_manager
end  
