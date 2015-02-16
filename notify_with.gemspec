$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "notify_with/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "notify_with"
  s.version     = NotifyWith::VERSION
  s.authors     = ["Peng DU"]
  s.email       = ["peng@sleede.com"]
  s.homepage    = "http://sleede.com"
  s.summary     = "A simple notification system for sleede rails project"
  s.description = "A simple notification system for sleede rails project"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 4.2.0"
  s.add_dependency "responders", "~> 2.0"
  s.add_dependency "jbuilder", "~> 2.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
end
