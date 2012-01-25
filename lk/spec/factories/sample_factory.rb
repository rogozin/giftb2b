#encoding: utf-8;
Factory.sequence :sample_seq do |n|
  "Образец №#{n}"
end

Factory.define :sample do |f|
  f.name {Factory.next(:sample_seq) }
  f.association :firm 
  f.association :supplier
  f.association :lk_firm 
  f.buy_price 100 
  f.sale_price 150
  f.buy_date { Date.yesterday }
  f.sale_date { Date.today }
  f.supplier_return_date { Date.today + 3 }
  f.client_return_date { Date.tomorrow }
  f.association :user, :factory => :firm_user
  f.association :responsible, :factory  => :firm_manager
  f.closed false
end  
