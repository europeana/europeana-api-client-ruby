# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'europeana/api/version'

Gem::Specification.new do |spec|
  spec.name          = 'europeana-api'
  spec.version       = Europeana::API::VERSION
  spec.authors       = ['Richard Doe']
  spec.email         = ['richard.doe@rwdit.net']
  spec.description   = 'Search and retrieve records from the Europeana REST API'
  spec.summary       = 'Ruby client library for the Europeana API'
  spec.homepage      = 'https://github.com/europeana/europeana-api-client-ruby'
  spec.license       = 'EUPL V.1.1'

  spec.files         = `git ls-files`.split($RS)
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'activesupport', '>= 4.2', '< 6.0'
  spec.add_dependency 'faraday', '~> 0.9'
  spec.add_dependency 'faraday_middleware'
  spec.add_dependency 'multi_json', '~> 1.0'
  spec.add_dependency 'rack', '> 1.6.2'
  spec.add_dependency 'typhoeus', '~> 1.1'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
