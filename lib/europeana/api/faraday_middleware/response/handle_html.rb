# frozen_string_literal: true
require 'faraday_middleware/response_middleware'

module Europeana
  module API
    module FaradayMiddleware
      ##
      # Handles HTML responses from the API, which are never desired
      class HandleHtml < ::FaradayMiddleware::ResponseMiddleware
        def process_response(env)
          super

          if env[:status] == 404
            fail Faraday::ResourceNotFound, env
          elsif (400..599).cover?(env[:status])
            fail Faraday::ClientError, env
          else
            fail Faraday::ParsingError, "API responded with HTML and status #{env[:status]}"
          end
        end
      end
    end
  end
end
