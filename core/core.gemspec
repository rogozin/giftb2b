$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gift-core"
  s.version     = Core::VERSION
  s.authors     = ["Ilya Rogozin"]
  s.email       = ["ilya.rogozin@gmail.com"]
  s.homepage    = "http://giftb2b.ru"
  s.summary     = "All core objects for project"
  s.description = "Description of Core."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.3"
  s.add_dependency "composite_primary_keys", "~> 4.1.1"
  s.add_dependency "paperclip"
  s.add_dependency "russian"

 # s.add_development_dependency "sqlite3"
end
