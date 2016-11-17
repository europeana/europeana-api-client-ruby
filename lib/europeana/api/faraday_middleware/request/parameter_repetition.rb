# frozen_string_literal: true
module Europeana
  module API
    module FaradayMiddleware
      ##
      # Handles multiple URL params with the same name
      #
      # Europeana's APIs expect params with the same name to appear in URL
      # queries like `?qf=this&qf=that`, but Faraday constructs them the
      # Rack/Rails way, like `?qf[]=this&qf[]=that`. This middleware constructs
      # them to the former format, using `Rack::Utils.build_query`.
      class ParameterRepetition < Faraday::Middleware
        def call(env)
          repeat_query_parameters(env)
          @app.call env
        end

        def repeat_query_parameters(env)
          query = Rack::Utils.parse_nested_query(env.url.query)
          env.url.query = Rack::Utils.build_query(query)
        end
      end
    end
  end
end
