# frozen_string_literal: true
require 'faraday_middleware/response_middleware'

module Europeana
  module API
    module FaradayMiddleware
      ##
      # Handles JSON-LD parsing of API responses
      #
      class JsonLdParser < ::FaradayMiddleware::ResponseMiddleware
        dependency do
          require 'json' unless defined?(JSON)
        end

        define_parser do |body|
          JSON.parse(body) unless body.strip.empty?
        end
      end
    end
  end
end
