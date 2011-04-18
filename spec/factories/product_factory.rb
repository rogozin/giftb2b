Factory.sequence :article_seq do |n|
   "000#{n}"
end

Factory.define :product do |f|
  f.article { Factory.next :article_seq }
  f.short_name { "product_" + Factory.next(:article_seq)}
  f.price 100 
  f.active true
  f.store_count 100
  f.association :manufactor
  f.association :supplier
  f.categories {|params| [params.association(:category)] }
end


Factory.sequence :manufactor_seq do |n| 
  "Manufactor #{n}"
end
Factory.define :manufactor do |f|
  f.name {Factory.next :manufactor_seq }
end


Factory.sequence :supplier_seq do |n| 
  "Supplier #{n}"
end

Factory.define :supplier do |f|
  f.name { Factory.next :supplier_seq  }
end

Factory.define :category do |f|
  f.name "Подарки"
  f.kind 1
  #f.permalink "podarki"
  f.active true
end
