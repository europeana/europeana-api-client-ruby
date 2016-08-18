# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'europeana/api/faraday_middleware'

module Europeana
  module API
    ##
    # The API client responsible for handling requests and responses
    class Client
      class << self
        def get(url, params = {}, headers = nil)
          connection.get(url, params, headers)
        end

        ##
        # `Faraday` connection to the API
        #
        # * Requests are retried 5 times at an interval of 3 seconds
        # * Requests are instrumented
        # * JSON responses are parsed
        #
        # @return [Faraday::Connection]
        def connection
          @connection ||= begin
            Faraday.new do |conn|
              conn.request :instrumentation
              conn.request :authenticated_request
              conn.url_prefix = Europeana::API.url
              conn.adapter Faraday.default_adapter
              conn.request :retry, max: 5, interval: 3,
                                   exceptions: [Errno::ECONNREFUSED, Errno::ETIMEDOUT, 'Timeout::Error',
                                                Faraday::Error::TimeoutError, EOFError]
              conn.response :json, content_type: /\bjson$/
            end
          end
        end
      end
    end
  end
end