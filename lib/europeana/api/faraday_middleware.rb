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

      autoload :HandleHtml, 'europeana/api/faraday_middleware/response/handle_html'

      Faraday::Request.register_middleware \
        authenticated_request: lambda { AuthenticatedRequest },
        parameter_repetition: lambda { ParameterRepetition }

      Faraday::Response.register_middleware \
        html: lambda { HandleHtml }
    end
  end
end
