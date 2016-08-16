# frozen_string_literal: true
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
        uri = request_uri(options)
        cache_response_body(uri) do
          response = Request.new(uri).execute
          parse_response(response, options)
        end
      rescue JSON::ParserError
        raise Errors::ResponseError
      end

      def cache_key(uri)
        "Europeana/API/#{uri}"
      end

      def cache_response_body(uri)
        Europeana::API.cache_store.fetch(cache_key(uri), expires_in: Europeana::API.cache_expires_in) do
          yield
        end
      end

      ##
      # Parses a JSON response from the API
      #
      # @param response (see Net::HTTP#request)
      # @param options [Hash] Options used by including class's implementation
      #   of this method
      # @return [HashWithIndifferentAccess] Parsed body of API response
      def parse_response(response, _options = {})
        JSON.parse(response.body).with_indifferent_access
      end

      ##
      # URI query param string
      #
      # @return [String]
      def request_uri_query
        params_with_authentication.each_with_object([]) do |(name, values), queries|
          [values].flatten.compact.each do |v|
            queries << CGI.escape(name.to_s) + '=' + CGI.escape(v.to_s)
          end
        end.join('&')
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
