# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

module Europeana
  module API
    ##
    # `Faraday` middleware for Europeana API specific behaviours
    module FaradayMiddleware
      autoload :AuthenticatedRequest, 'europeana/api/faraday_middleware/authenticated_request'
      autoload :JsonParser, 'europeana/api/faraday_middleware/json_parser'
      autoload :ParameterRepetition, 'europeana/api/faraday_middleware/parameter_repetition'

      Faraday::Request.register_middleware \
        authenticated_request: lambda { AuthenticatedRequest }

      Faraday::Response.register_middleware \
        json_parser: lambda { JsonParser }
    end
  end
end
