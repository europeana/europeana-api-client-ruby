# frozen_string_literal: true
module Europeana
  module API
    module Response
      class << self
        # @param [Faraday::Response]
        # @return [OpenStruct] Response body
        def validate!(response, endpoint)
          return if response.body[:success]
          validate_endpoint_errors!(response, endpoint)
          validate_generic_errors!(response)
        end

        def validate_endpoint_errors!(response, endpoint)
          (endpoint[:errors] || {}).each_pair do |error_pattern, exception_class|
            fail exception_class, response.body[:error] if response.body[:error] =~ Regexp.new(error_pattern)
          end
        end

        def validate_generic_errors!(response)
          fail Errors::ResourceNotFoundError, response.body[:error] if response.status == 404
          fail Errors::MissingAPIKeyError, response.body[:error] if response.status == 403 && response.body[:error] =~ /No API key/
          fail Errors::ClientError, response.body[:error] if (400..499).include?(response.status)
          fail Errors::ServerError, response.body[:error] if (400..499).include?(response.status)
        end
      end
    end
  end
end
