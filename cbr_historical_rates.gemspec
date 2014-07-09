$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cbr_historical_rates/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cbr_historical_rates"
  s.version     = CbrHistoricalRates::VERSION
  s.authors     = ["Alexander Malaev"]
  s.email       = ["scream@spuge.net"]
  s.homepage    = "http://github.com/spscream/cbr_historical_rates"
  s.summary     = "CbrHistoricalRates extends "
  s.description = "TODO: Description of CbrHistoricalRates."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'money', '>=5.0'
  s.add_dependency 'savon', '~>2.0'
end
