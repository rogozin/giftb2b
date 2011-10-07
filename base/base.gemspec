$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "base/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gift-base"
  s.version     = Base::VERSION
  s.authors     = ["Ilya Rogozin"]
  s.email       = ["ilya.rogozing@gmail.com"]
  s.homepage    = "http://giftb2b.ru"
  s.summary     = "TODO: Summary of Base."
  s.description = "TODO: Description of Base."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.1.0"
  s.add_dependency "will_paginate"
  s.add_dependency "RedCloth"
  # s.add_dependency "jquery-rails"

#  s.add_development_dependency "sqlite3"
end
