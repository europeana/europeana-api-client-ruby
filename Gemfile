source 'https://rubygems.org'

# Specify your gem's dependencies in europeana.gemspec
gemspec

group :test do
  gem 'coveralls', require: false
end

group :test, :develop do
  gem 'dotenv'
  gem 'rubocop', '0.39.0', require: false # only update when Hound does
end
