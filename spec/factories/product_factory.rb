Factory.define :product do |f|
  f.article '000001'
  f.short_name "product"
  f.price 100 
  f.active true
  f.association :manufactor
  f.association :supplier
end

Factory.define :manufactor do |f|
  f.name "Manufactor"
end

Factory.define :supplier do |f|
  f.name "Supplier"
end
