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
      end
    end
  end
end
