require 'faraday'
require 'faraday_middleware'

module Europeana
  module API
    ##
    # The API client responsible for handling requests and responses
    class Client
      class << self
        ##
        # Send an HTTP request to a URL
        #
        # @param url [String,URI] URL for the request
        # @return [Faraday::Response] API response
        # @todo validate `method`
        def request(url:, method: :get, params: nil, headers: nil)
          connection.send(method, url, params, headers)
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
              conn.adapter Faraday.default_adapter
              conn.request :instrumentation
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
