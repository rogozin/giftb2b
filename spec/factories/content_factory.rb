#encoding: utf-8;
Factory.sequence :content_seq do |n|
    n.to_s 
  end

Factory.sequence :content_category_seq do |n|
    n.to_s 
  end

Factory.define :content do |f|
  f.title { "title " + Factory.next(:content_seq)}
  f.body { "Съешь еще #{Factory.next(:content_seq)} раз этих мягких француских булок!" }
end

Factory.define :content_category do |f|
  f.name { "content category " + Factory.next(:content_category_seq)}
end

Factory.define :banner do |f|
  f.firm_id 1
  f.text  "<div id=\"test_banner\" style=\"font-size:2em\">БАННЕР</div>"
  f.active true
end
