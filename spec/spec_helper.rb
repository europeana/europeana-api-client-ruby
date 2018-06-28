# frozen_string_literal: true

# Generate Simplecov report
require 'simplecov'
SimpleCov.start

require 'europeana/api'
require 'shoulda/matchers'
require 'webmock/rspec'

Dir['./spec/support/**/*.rb'].each { |f| require f }

Europeana::API.logger.level = Logger::ERROR

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
  end
end
