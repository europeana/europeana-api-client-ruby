# frozen_string_literal: true
require 'rack'

module Europeana
  module API
    module FaradayMiddleware
      ##
      # `Faraday` middleware to handle Europeana API authentication
      class AuthenticatedRequest < Faraday::Middleware
        def call(env)
          ensure_api_key(env)
          @app.call env
        end

        def ensure_api_key(env)
          query = Rack::Utils.parse_query(env.url.query)
          return if query.key?('wskey')

          query['wskey'] = Europeana::API.key
          env.url.query = Rack::Utils.build_query(query)
        end
      end
    end
  end
end
