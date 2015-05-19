require 'active_support/benchmarkable'
require 'net/http'

module Europeana
  module API
    ##
    # Europeana API request
    class Request
      include ActiveSupport::Benchmarkable

      # Request URI
      attr_reader :uri

      # API response
      attr_reader :response

      # @param [URI]
      def initialize(uri)
        @uri = uri
      end

      # @return (see Net::HTTP#request)
      def execute
        benchmark("Request query", level: :info) do
          http = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Get.new(uri.request_uri)
          retries = Europeana::API.max_retries

          begin
            attempt = Europeana::API.max_retries - retries + 1
            logger.info("Request URL: #{uri} (attempt ##{attempt})")
            @response = http.request(request)
          rescue Timeout::Error, Errno::ECONNREFUSED, EOFError
            retries -= 1
            raise unless retries > 0
            logger.warn("Network error; sleeping #{Europeana::API.retry_delay}s")
            sleep Europeana::API.retry_delay
            retry
          end

          @response
        end
      end

      def logger
        Europeana::API.logger
      end
    end
  end
end
