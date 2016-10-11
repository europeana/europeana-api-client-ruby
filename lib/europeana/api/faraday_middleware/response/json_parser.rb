# frozen_string_literal: true
require 'faraday_middleware/response_middleware'

module Europeana
  module API
    module FaradayMiddleware
      ##
      # Handles JSON parsing of API responses
      #
      # Returns each object not as a `Hash` but as an `OpenStruct`.
      #
      # @todo Deal with cases where Europeana APIs return non-JSON responses (when
      #   they should not), and detects request failures from flags and messages
      #   in JSON responses.
      class JsonParser < ::FaradayMiddleware::ResponseMiddleware
        dependency do
          require 'json' unless defined?(JSON)
        end

        define_parser do |body|
          JSON.parse(body, object_class: OpenStruct) unless body.strip.empty?
        end
      end
    end
  end
end
