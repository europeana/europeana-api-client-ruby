# frozen_string_literal: true
require 'faraday_middleware/response_middleware'
require 'active_support/json'

module Europeana
  module API
    module FaradayMiddleware
      ##
      # Handles JSON parsing of API responses
      #
      # Returns the response as either a `Hash` (default) or an `OpenStruct`.
      #
      # To set the response format to be `OpenStruct`:
      # ```ruby
      # Europeana::API.configure do |config|
      #   config.parse_json_to = OpenStruct
      # end
      # ```
      #
      # If using `OpenStruct`, changes "-" in JSON field keys to "_", so that
      # they become methods.
      class ParseJsonToVarious < ::FaradayMiddleware::ResponseMiddleware
        dependency do
          require 'json' unless defined?(JSON)
        end

        define_parser do |body|
          unless body.strip.empty?
            hash = JSON.parse(body)
            if Europeana::API.configuration.parse_json_to == OpenStruct
              underscored_hash = underscore_hash_keys(hash)
              underscored_body = underscored_hash.to_json
              JSON.parse(underscored_body, object_class: OpenStruct)
            else
              hash
            end
          end
        end

        class << self
          def underscore_hash_keys(hash)
            hash.keys.each do |k|
              hash[k] = underscore_hash_keys(hash[k]) if hash[k].is_a?(Hash)
              hash[k.underscore] = hash.delete(k) if k =~ /-/
            end
            hash
          end
        end
      end
    end
  end
end
