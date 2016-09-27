module Europeana
  module API
    ##
    # Interface to the Europeana API Record method
    #
    # @see http://labs.europeana.eu/api/record/
    class Record
      autoload :Hierarchy, 'europeana/api/record/hierarchy'

      include Requestable

      # Europeana ID of the record
      attr_reader :id

      # Request parameters to send to the API
      attr_reader :params

      ##
      # @param [String] id Europeana ID of the record
      # @param [Hash] params Request parameters
      def initialize(id, params = {})
        self.request_params = params
        @id = id
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
      # Gets the URL for this Record request
      #
      # @param [Hash{Symbol => Object}] options
      # @option options [Boolean] :ld (false)
      #   Request JSON-LD
      # @return [String]
      def request_url(options = {})
        options.assert_valid_keys(:ld)
        (api_url + "/record#{@id}.json").tap do |url|
          url << 'ld' if options[:ld]
        end
      end

      alias_method :get, :execute_request

      ##
      # Examines the `success` and `error` fields of the response for failure
      #
      # @raise [Europeana::Errors::RequestError] if API response has
      #   `success:false`
      # @raise [Europeana::Errors::RequestError] if API response has 404 status
      #   code
      # @see Requestable#parse_response
      def parse_response(response, options = {})
        super.tap do |body|
          if (options[:ld] && !(200..299).include?(response.code.to_i)) || (!options[:ld] && !body[:success])
            fail Errors::RequestError, (body.key?(:error) ? body[:error] : response.code)
          end
        end
      rescue JSON::ParserError
        if response.code.to_i == 404
          # Handle HTML 404 responses on malformed record ID, emulating API's
          # JSON response.
          raise Errors::RequestError, "Invalid record identifier: #{@id}"
        else
          raise
        end
      end

      def hierarchy
        @hierarchy ||= Hierarchy.new(id)
      end
    end
  end
end
