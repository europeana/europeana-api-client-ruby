# frozen_string_literal: true
module Europeana
  module API
    class Response
      attr_reader :faraday_response, :request

      delegate :body, :headers, :status, to: :faraday_response
      delegate :endpoint, to: :request

      def initialize(request, faraday_response)
        @request = request
        @faraday_response = faraday_response
      end

      def validate!
        return if body[:success]
        validate_endpoint_errors!
        validate_generic_errors!
      end

      def validate_endpoint_errors!
        (endpoint[:errors] || {}).each_pair do |error_pattern, exception_class|
          fail exception_class, body[:error] if body[:error] =~ Regexp.new(error_pattern)
        end
      end

      def validate_generic_errors!
        fail Errors::ResourceNotFoundError, body[:error] if status == 404
        fail Errors::MissingAPIKeyError, body[:error] if status == 403 && body[:error] =~ /No API key/
        fail Errors::ClientError, body[:error] if (400..499).include?(status)
        fail Errors::ServerError, body[:error] if (400..499).include?(status)
      end
    end
  end
end
