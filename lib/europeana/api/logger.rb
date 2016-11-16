# frozen_string_literal: true
require 'active_support/notifications'

# Subscribe to Faraday request instrumentation
ActiveSupport::Notifications.subscribe('request.faraday') do |_name, starts, ends, _id, env|
  url = env[:url]
  http_method = env[:method].to_s.upcase
  duration = ends - starts
  Europeana::API.logger.info(format('%s %s (%.3f s)', http_method, url, duration)
end
