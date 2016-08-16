require 'faraday'

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
        def request(url:, method: :get)
          connection.send(method, url)
        end

        ##
        # `Faraday` connection to the API
        #
        # * Requests are retried 5 times at an interval of 3 seconds
        # * Requests are instrumented
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
            end
          end
        end
      end
    end
  end
end
