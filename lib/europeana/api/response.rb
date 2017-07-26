# frozen_string_literal: true
module Europeana
  module API
    class Response
      attr_reader :faraday_response, :request, :error_message

      delegate :body, :headers, :status, to: :faraday_response
      delegate :endpoint, to: :request

      # @param request [Europeana::API::Request]
      # @param faraday_response [Faraday::Response]
      def initialize(request, faraday_response)
        @request = request
        @faraday_response = faraday_response
        @error_message = detect_error_message
      end

      def validate!
        return if body.is_a?(Hash) && body[:success]
        validate_endpoint_errors!
        validate_generic_errors!
      end

      def validate_endpoint_errors!
        (endpoint[:errors] || {}).each_pair do |error_pattern, exception_class|
          fail exception_class.new(faraday_response), error_message if error_message =~ Regexp.new(error_pattern)
        end
      end

      def validate_generic_errors!
        fail Errors::ResourceNotFoundError.new(faraday_response), error_message if status == 404
        fail Errors::MissingAPIKeyError.new(faraday_response), error_message if status == 403 && error_message =~ /No API key/
        fail Errors::ClientError.new(faraday_response), error_message if (400..499).cover?(status)
        fail Errors::ServerError.new(faraday_response), error_message if (500..599).cover?(status)
      end

      def detect_error_message
        return nil unless (400..599).cover?(status)
        if body.is_a?(Hash) && body.key?(:error)
          body[:error]
        else
          Rack::Utils::HTTP_STATUS_CODES[status]
        end
      end
    end
  end
end
