module Europeana
  module API
    ##
    # Interface to Europeana API's Search method
    class Search
      autoload :Fields, 'europeana/api/search/fields'

      include Requestable

      # Query params
      attr_accessor :params

      class << self
        ##
        # Escapes Lucene syntax special characters for use in query parameters
        #
        # @param [String] text Text to escape
        # @return [String] Escaped text
        def escape(text)
          fail ArgumentError, "Expected String, got #{text.class}" unless text.is_a?(String)
          specials = %w<\\ + - & | ! ( ) { } [ ] ^ " ~ * ? : / >
          specials.each_with_object(text.dup) do |char, unescaped|
            unescaped.gsub!(char, '\\\\' + char) # prepends *one* backslash
          end
        end
      end

      ##
      # @param [Hash] params Europeana API request parameters for Search query
      def initialize(params = {})
        @params = HashWithIndifferentAccess.new(params)
      end

      ##
      # Base URL for a Search request
      #
      # @return [URI]
      def request_url(_options = {})
        Europeana::API.url + '/search.json'
      end

      alias_method :execute, :execute_request

      ##
      # Examines the `success` and `error` fields of the response for failure
      #
      # @raise [Europeana::Errors::RequestError] if API response has
      #   `success:false`
      # @see Requestable#parse_response
      def parse_response(response, _options = {})
        super.tap do |body|
          unless body[:success]
            if body.key?(:error) && body[:error] =~ /1000 search results/
              klass = Errors::Request::PaginationError
            else
              klass = Errors::RequestError
            end
            fail klass, (body.key?(:error) ? body[:error] : response.code)
          end
        end
      end
    end
  end
end
