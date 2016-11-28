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
      autoload :ParseJsonToVarious, 'europeana/api/faraday_middleware/response/parse_json_to_various'

      Faraday::Request.register_middleware \
        authenticated_request: -> { AuthenticatedRequest },
        parameter_repetition: -> { ParameterRepetition }

      Faraday::Response.register_middleware \
        html: -> { HandleHtml },
        json_various: -> { ParseJsonToVarious }
    end
  end
end
