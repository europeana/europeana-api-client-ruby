module Europeana
  module API
    ##
    # Interface to the Europeana API Record method
    #
    # @see http://labs.europeana.eu/api/record/
    class Record
      # Europeana ID of the record
      attr_accessor :id

      # Request parameters to send to the API
      attr_accessor :params

      ##
      # @param [String] id Europeana ID of the record
      # @param [Hash] params Request parameters
      def initialize(id, params = {})
        self.id = id
        self.params = params
        @hierarchy = HashWithIndifferentAccess.new
      end

      ##
      # Returns query params with API key added
      #
      # @return [Hash]
      def params_with_authentication
        return params if params.key?(:wskey) && params[:wskey].present?
        unless Europeana::API.api_key.present?
          fail Errors::MissingAPIKeyError
        end
        params.merge(wskey: Europeana::API.api_key)
      end

      ##
      # Sets record ID attribute after validating format.
      #
      # @param [String] id Record ID
      #
      def id=(id)
        unless id.is_a?(String) && id.match(%r{\A/[^/]+/[^/]+\B})
          fail ArgumentError, "Invalid Europeana record ID: \"#{id}\""
        end
        @id = id
      end

      ##
      # Sets request parameters after validating keys
      #
      # Valid parameter keys:
      # * :callback
      #
      # For explanations of these request parameters, see: http://labs.europeana.eu/api/record/
      #
      # @param (see #initialize)
      # @return [Hash] Request parameters
      def params=(params = {})
        params.assert_valid_keys(:callback, :wskey)
        @params = params
      end

      ##
      # Gets the URI for this Record request with parameters
      #
      # @param [Hash{Symbol => Object}] options
      # @option options [Boolean] :ld (false)
      #   Request JSON-LD
      # @return [URI]
      def request_uri(options = {})
        url = Europeana::API.url + "/record#{@id}.json"
        url << 'ld' if options[:ld]
        uri = URI.parse(url)
        uri.query = params_with_authentication.to_query
        uri
      end

      ##
      # Sends a request for this record to the API
      #
      # @param [Hash{Symbol => Object}] options
      # @option options [Boolean] :ld (false)
      #   Request JSON-LD
      # @return [Hash]
      # @raise [Europeana::Errors::ResponseError] if API response could not be
      #   parsed as JSON
      # @raise [Europeana::Errors::RequestError] if API response has
      #   `success:false`
      # @raise [Europeana::Errors::RequestError] if API response has 404 status
      #   code
      def get(options = {})
        request = Request.new(request_uri(options))
        response = request.execute
        body = JSON.parse(response.body)
        if (options[:ld] && !(200..299).include?(response.code.to_i)) || (!options[:ld] && !body['success'])
          fail Errors::RequestError, (body.key?('error') ? body['error'] : response.code)
        end
        body
      rescue JSON::ParserError
        if response.code.to_i == 404
          # Handle HTML 404 responses on malformed record ID, emulating API's
          # JSON response.
          raise Errors::RequestError, "Invalid record identifier: #{@id}"
        else
          raise Errors::ResponseError
        end
      end

      ##
      # Gets hierarchy data about this and related records from
      # ancestor-self-siblings.json API method
      #
      # @note Proof of concept implementation for demo purposes.
      # @todo Refactor if functionality to be retained.
      def hierarchy(*args)
        args = [:self] if args.blank?

        data = {}
        args.each do |method|
          unless @hierarchy.key?(method)
            @hierarchy[method] = hierarchical_data(method).select do |_k, v|
              v.is_a?(Enumerable)
            end
          end
          data.merge!(@hierarchy[method])
        end
        data
      end

      def hierarchical_data(method = :self)
        request = Request.new(hierarchical_data_uri(method))
        response = request.execute
        body = JSON.parse(response.body)
        fail Errors::RequestError, body['message'] unless body['success']
        body
      rescue JSON::ParserError
        if response.code.to_i == 404
          # Handle HTML 404 responses on malformed record ID, emulating API's
          # JSON response.
          raise Errors::RequestError, "Invalid record identifier: #{@id}"
        else
          raise Errors::ResponseError
        end
      end

      def hierarchical_data_uri(method = :self)
        uri = URI.parse(Europeana::API.url + "/record#{@id}/#{method}.json")
        uri.query = params_with_authentication.to_query
        uri
      end
    end
  end
end
