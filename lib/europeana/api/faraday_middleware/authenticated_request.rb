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

          fail Errors::MissingAPIKeyError unless Europeana::API.api_key.present?
          query['wskey'] = Europeana::API.api_key
          env.url.query = Rack::Utils.build_query(query)
        end
      end
    end
  end
end
