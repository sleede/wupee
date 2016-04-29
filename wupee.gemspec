$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "wupee/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "wupee"
  s.version     = Wupee::VERSION
  s.authors     = ["Peng DU", "Nicolas Florentin"]
  s.email       = ["peng@sleede.com", "nicolas@sleede.com"]
  s.homepage    = "https://github.com/sleede/wupee"
  s.summary     = "Simple notification system for rails"
  s.description = "Simple notification system for rails"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", '>= 4.2.0'
  #s.add_dependency "responders", "~> 2.0"
  s.add_dependency "jbuilder", "~> 2.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
end
