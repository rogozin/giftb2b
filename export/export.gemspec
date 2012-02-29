$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "export/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gift-export"
  s.version     = Export::VERSION
  s.authors     = ["Ilya M Rogozin"]
  s.email       = ["ilya.rogozin@gmail.com"]
  s.homepage    = "giftb2b.ru"
  s.summary     = "Giftb2b core data export gem"
  s.description = "This gem can export db data to other formats, like csv"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.3"
  s.add_dependency "gift-core"
  s.add_dependency "sitemap_generator"
  
end
