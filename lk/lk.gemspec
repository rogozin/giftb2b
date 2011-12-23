#encoding:utf-8;
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "lk/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gift-lk"
  s.version     = Lk::VERSION
  s.authors     = ["Ilya Rogozin"]
  s.email       = ["ilya.rogozin@giftb2b.ru"]
  s.homepage    = "http://giftpoisk.ru/lk"
  s.summary     = "Личный кабинет для рекламных агентств"
  s.description = "Удобный полнофункциональный инструмент для автоматизации работы рекламного агентства"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.3"
  s.add_dependency "jquery-rails"
  s.add_dependency "composite_primary_keys", "~> 4.1.1"
  s.add_dependency "paperclip"
  s.add_dependency "gift-core"
  s.add_dependency "gift-auth"
  s.add_dependency "gift-base"
  s.add_dependency 'pdfkit'
  s.add_dependency 'writeexcel', "0.6.9"
  s.add_dependency "will_paginate"
  s.add_dependency "tinymce-rails"
  s.add_dependency "remotipart"
end
