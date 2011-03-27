Factory.define :product do |f|
  f.article '000001'
  f.short_name "product"
  f.price 100 
  f.active true
  f.store_count 100
  f.association :manufactor
  f.association :supplier
  f.categories {|params| [params.association(:category)] }
end

Factory.define :manufactor do |f|
  f.name "Manufactor"
end

Factory.define :supplier do |f|
  f.name "Supplier"
end

Factory.define :category do |f|
  f.name "Подарки"
  f.kind 1
  f.permalink "podarki"
  f.active true
end
