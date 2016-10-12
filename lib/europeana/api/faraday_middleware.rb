# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

module Europeana
  module API
    ##
    # `Faraday` middleware for Europeana API specific behaviours
    module FaradayMiddleware
      autoload :AuthenticatedRequest, 'europeana/api/faraday_middleware/request/authenticated_request'
      autoload :ParameterRepetition, 'europeana/api/faraday_middleware/request/parameter_repetition'

      autoload :HtmlHandler, 'europeana/api/faraday_middleware/response/html_handler'

      Faraday::Request.register_middleware \
        authenticated_request: lambda { AuthenticatedRequest },
        parameter_repetition: lambda { ParameterRepetition }

      Faraday::Response.register_middleware \
        html_handler: lambda { HtmlHandler }
    end
  end
end
