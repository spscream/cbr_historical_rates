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
  s.description = "CbrHistoricalRates extends Money::Bank::VariableExchange and gives you an access to Russian Central Bank exchange rates with historical data."
  s.summary     = "Access to Central Bank of Russia currency exchange rates."
  s.license     = "MIT"

  s.files         = `git ls-files`.split($/)
  s.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_development_dependency 'minitest', '>=2.0'
  s.add_development_dependency 'rr', '>=1.0.4'
  s.add_dependency 'money', '>=5.0'
  s.add_dependency 'savon', '~>2.0'
end
