$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'dradis/plugins/pentera/version'
version = Dradis::Plugins::Pentera::VERSION::STRING

Gem::Specification.new do |spec|
  spec.name        = 'dradis-pentera'
  spec.version     = version
  spec.authors     = ['Aaron Manaloto']
  spec.homepage    = 'https://dradis.com/integrations/pentera.html'
  spec.summary     = 'Pentera upload add-on for Dradis Framework.'
  spec.description = 'This add-on allows you to upload and parse pentera reports'
  spec.license     = 'GPL-2'

  spec.files = `git ls-files`.split($\)

  spec.add_dependency 'dradis-plugins', '~> 4.0'

  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'combustion', '~> 0.5.2'
  spec.add_development_dependency 'multi_json', '~> 1.15.0'
end
