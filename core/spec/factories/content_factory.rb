#encoding: utf-8;
Factory.sequence :c_seq do |n|
    n.to_s 
  end

Factory.sequence :content_category_seq do |n|
    n.to_s 
  end

Factory.define :content do |f|
  f.title { "title " + Factory.next(:c_seq)}
  f.body { "Съешь еще #{Factory.next(:c_seq)} раз этих мягких француских булок!" }
end

Factory.define :content_category do |f|
  f.name { "content category " + Factory.next(:content_category_seq)}
end

Factory.define :banner do |f|
  f.firm_id 1
  f.text  "<div id=\"test_banner\" style=\"font-size:2em\">БАННЕР</div>"
  f.active true
end

Factory.define :news do |f|
  f.firm_id 1
  f.title "Новость дня"
  f.body  "Сегодня под мостом нашли бобра с хвостом"
  f.state_id 1
end
