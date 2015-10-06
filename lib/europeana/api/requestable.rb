require 'active_support/core_ext/hash/indifferent_access'

module Europeana
  module API
    ##
    # Mixin for classes that need to make Europeana API requests
    #
    # Class needs to implement {#request_url}
    module Requestable
      ##
      # Request-specific params, to be overriden in including class
      #
      # @return [Hash]
      def params
        {}
      end

      ##
      # Query params with API key added
      #
      # @return [Hash]
      def params_with_authentication
        return params if params.key?(:wskey) && params[:wskey].present?
        unless Europeana::API.api_key.present?
          fail Europeana::API::Errors::MissingAPIKeyError
        end
        params.merge(wskey: Europeana::API.api_key)
      end

      ##
      # Execute the API request
      #
      # @param options [Hash] Options sent on to {#request_uri} and {#parse_response}
      # @return (see #parse_response)
      # @raise [Europeana::Errors::ResponseError] if API response could not be
      #   parsed as JSON
      def execute_request(options = {})
        response = Request.new(request_uri(options)).execute
        parse_response(response, options)
      rescue JSON::ParserError
        raise Errors::ResponseError
      end

      ##
      # Parses a JSON response from the API
      #
      # @param response (see Net::HTTP#request)
      # @param options [Hash] Options used by including module implementation
      # @return [HashWithIndifferentAccess] Parsed body of API response
      def parse_response(response, options = {})
        JSON.parse(response.body).with_indifferent_access
      end

      ##
      # URI query param string
      #
      # @return [String]
      def request_uri_query
        ''.tap do |uri_query|
          params_with_authentication.each_pair do |name, value|
            [value].flatten.each do |v|
              uri_query << '&' unless uri_query.blank?
              uri_query << CGI.escape(name.to_s) + '=' + CGI.escape(v.to_s)
            end
          end
        end
      end

      ##
      # Gets the URI for this request, with any query parameters
      #
      # @param [Hash{Symbol => Object}] options passed to {#request_url}
      # @return [String]
      def request_uri(options = {})
        URI.parse(request_url(options)).tap do |uri|
          uri.query = request_uri_query
        end
      end

      ##
      # URL for the request, without query params
      #
      # To be implemented by the including class
      #
      # @param options [Hash] Options used by implementation
      # @return [String] Request URL
      def request_url(_options = {})
        fail NotImplementedError, "Requestable class #{self.class} does not implement #request_url"
      end
    end
  end
end
