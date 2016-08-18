module Europeana
  module API
    module FaradayMiddleware
      ##
      # Handles JSON parsing of API responses
      #
      # Deals with cases where Europeana APIs return non-JSON responses (when
      # they should not), and detects request failures from flags and messages
      # in JSON responses.
      class JsonParser < Faraday::Middleware
      end
    end
  end
end
