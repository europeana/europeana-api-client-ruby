require 'active_support/benchmarkable'
require 'net/http'

module Europeana
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
      logger.debug("Europeana::Request API URL: #{uri}")

      benchmark('Europeana::Request API query', level: :debug) do
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        retries = Europeana.max_retries

        begin
          @response = http.request(request)
        rescue Timeout::Error, Errno::ECONNREFUSED, EOFError
          retries -= 1
          raise unless retries > 0
          sleep Europeana.retry_delay
          retry
        end

        @response
      end
    end

    def logger
      Europeana.logger
    end
  end
end
