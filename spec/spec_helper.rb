require 'coveralls'
require 'europeana/api'
require 'webmock/rspec'

Dir["./spec/support/**/*.rb"].each { |f| require f }

Coveralls.wear! unless Coveralls.will_run?.nil?

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
