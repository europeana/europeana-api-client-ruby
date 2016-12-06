# frozen_string_literal: true
module Europeana
  module API
    ##
    # An API request
    class Request
      attr_reader :endpoint
      attr_reader :params
      attr_reader :api_url
      attr_reader :headers
      attr_reader :body
      attr_writer :client

      ##
      # @param endpoint [Hash] endpoint options
      # @param params [Hash]
      def initialize(endpoint, params = {})
        @endpoint = endpoint
        @params = params.dup
        extract_special_params
      end

      ##
      # @return [Response]
      def execute(&block)
        response = Response.new(self, faraday_response(&block))
        return response if client.in_parallel?

        response.validate!
        response.body
      end

      def url
        build_api_url(format_params)
      end

      def client
        @client ||= Client.new
      end

      protected

      def extract_special_params
        @api_url = @params.delete(:api_url)
        @headers = @params.delete(:headers)
        @body = @params.delete(:body) unless http_method == :get
      end

      def faraday_response
        client.send(http_method) do |request|
          request.url(url)
          request.params = query_params
          request.headers.merge!(endpoint[:headers] || {}).merge!(headers || {})
          request.body = body unless http_method == :get
          yield(request) if block_given?
          # logger.debug("API request: #{request.inspect}")
        end
      end

      def logger
        Europeana::API.logger
      end

      def http_method
        endpoint[:method] || :get
      end

      def format_params
        params.slice(*endpoint_path_format_keys)
      end

      def query_params
        params.except(*endpoint_path_format_keys)
      end

      def endpoint_path_format_keys
        @endpoint_path_format_keys ||= endpoint[:path].scan(/%\{(.*?)\}/).flatten.map(&:to_sym)
      end

      def build_api_url(params = {})
        request_path = format(endpoint[:path], params)
        if api_url.nil?
          request_path.sub(%r{\A/}, '') # remove leading slash for relative URLs
        else
          api_url + request_path
        end
      end
    end
  end
end
