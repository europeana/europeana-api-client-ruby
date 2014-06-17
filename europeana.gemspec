# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'europeana/version'

Gem::Specification.new do |spec|
  spec.name          = "europeana"
  spec.version       = Europeana::VERSION
  spec.authors       = ["Richard Doe"]
  spec.email         = ["richard.doe@rwdit.net"]
  spec.description   = %q{Provides an interface to the Europeana API}
  spec.summary       = %q{Search and retrieve records from the Europeana portal API}
  spec.homepage      = "https://github.com/europeana/europeana-client-ruby"
  spec.license       = "EUPL 1.1"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 3.0"
  spec.add_dependency "multi_json", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 1.18.0"
end
