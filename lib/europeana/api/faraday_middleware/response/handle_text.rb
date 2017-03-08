# frozen_string_literal: true
require 'faraday_middleware/response_middleware'

module Europeana
  module API
    module FaradayMiddleware
      ##
      # Handles plain text & HTML responses from the API, which are never desired
      class HandleText < ::FaradayMiddleware::ResponseMiddleware
        def process_response(env)
          super
          content_type = env.response_headers['Content-Type']
          fail Europeana::API::Errors::ResponseError.new(env),
               %(API responded with Content-Type "#{content_type}" and status #{env[:status]})
        end
      end
    end
  end
end
