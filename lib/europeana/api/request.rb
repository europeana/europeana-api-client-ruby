# frozen_string_literal: true
module Europeana
  module API
    ##
    # An API request
    class Request
      attr_reader :endpoint
      attr_reader :params
      attr_reader :api_url

      ##
      # @param endpoint [Hash] endpoint options
      # @param params [Hash]
      def initialize(endpoint, **params)
        @endpoint = endpoint
        @params = params.dup
        @api_url = @params.delete(:api_url)
      end

      ##
      # @return [Faraday::Response]
      def execute
        response = Client.get(url, **query_params)
        inspect_response_for_errors(response)
        response.body
      end

      def url
        build_api_url(**format_params)
      end

      protected

      def format_params
        params.slice(*endpoint_path_format_keys)
      end

      def query_params
        params.except(*endpoint_path_format_keys)
      end

      def endpoint_path_format_keys
        @endpoint_path_format_keys ||= endpoint[:path].scan(/%\{(.*?)\}/).flatten.map(&:to_sym)
      end

      def build_api_url(**params)
        request_path = format(endpoint[:path], params)
        if api_url.nil?
          request_path.sub(%r{\A/}, '') # remove leading slash for relative URLs
        else
          api_url + request_path
        end
      end

      def inspect_response_for_errors(response)
        return if response.body[:success]

        # Endpoint specific errors
        (endpoint[:errors] || {}).each_pair do |error_pattern, exception_class|
          fail exception_class, response.body[:error] if response.body[:error] =~ Regexp.new(error_pattern)
        end

        # Generic errors
        fail Errors::ResourceNotFoundError, response.body[:error] if response.status == 404
        fail Errors::MissingAPIKeyError, response.body[:error] if response.status == 403 && response.body[:error] =~ /No API key/
        fail Errors::ClientError, response.body[:error] if (400..499).include?(response.status)
        fail Errors::ServerError, response.body[:error] if (400..499).include?(response.status)
      end
    end
  end
end
