$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "auth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gift-auth"
  s.version     = Auth::VERSION
  s.authors     = ["Ilya Rogozin"]
  s.email       = ["ilya.rogozin@gmail.com"]
  s.homepage    = "http://giftb2b.ru"
  s.summary     = "TODO: Summary of Auth."
  s.description = "TODO: Description of Auth."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.2"
  s.add_dependency "authlogic"
  s.add_dependency "acl9"
  # s.add_dependency "jquery-rails"
end
