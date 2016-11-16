# frozen_string_literal: true
require 'faraday_middleware/response_middleware'
require 'active_support/json'

module Europeana
  module API
    module FaradayMiddleware
      ##
      # Handles JSON parsing of API responses
      #
      # Returns each object not as a `Hash` but as an `OpenStruct`.
      #
      # Changes "-" in JSON field keys to "_", so that they become methods
      # on the `OpenStruct`.
      class ParseJsonToOpenStruct < ::FaradayMiddleware::ResponseMiddleware
        dependency do
          require 'json' unless defined?(JSON)
        end

        define_parser do |body|
          unless body.strip.empty?
            hash = JSON.parse(body)
            underscored_hash = underscore_hash_keys(hash)
            underscored_body = underscored_hash.to_json
            JSON.parse(underscored_body, object_class: OpenStruct)
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
