# frozen_string_literal: true
source 'https://rubygems.org'

# Specify your gem's dependencies in europeana.gemspec
gemspec

group :develop, :test do
  gem 'dotenv'
  gem 'rubocop', '0.39.0', require: false # only update when Hound does
end

group :test do
  gem 'coveralls', require: false
  gem 'rspec', '~> 3.0'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'webmock', '~> 1.18.0'
end
