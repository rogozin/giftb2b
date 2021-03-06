#encoding: utf-8;
Factory.sequence :article_seq do |n|
   "000#{n}"
end

Factory.define :product do |f|
  f.article { Factory.next :article_seq }
  f.short_name { "product_" + Factory.next(:article_seq)}
  f.price 100 
  f.active true
#  f.store_count 100
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

Factory.sequence :category_seq do |n| 
  "Подарки #{n}"
end

Factory.define :category do |f|
  f.name { Factory.next :category_seq }
  f.kind 1
  #f.permalink "podarki"
  f.active true
end

Factory.define :text_property, :class => Property do |f|
  f.name "Текстовое св-во" 
  f.for_search true
  f.for_all_products  true
  f.property_type 0
  f.active true
end

Factory.define :color_property, :class => Property do |f|
  f.name "Цветовые варианты" 
  f.property_type 3
  f.active true
  f.show_in_card true
end

Factory.define :store do |f|
  f.association :supplier
  f.name  "основной"  
  f.delivery_time "2 недели"
  f.location "Европа"
  f.after_create { |store| store.update_attribute :name, "#{store.name}-#{store.id}"  }  
end
