# frozen_string_literal: true
module Europeana
  class Record
    ##
    # Interface to Europeana API's Record search
    class Search < Resource
      autoload :Fields, 'europeana/record/search/fields'

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
            klass = if body.key?(:error) && body[:error] =~ /1000 search results/
                      API::Errors::Request::PaginationError
                    else
                      API::Errors::RequestError
                    end
            fail klass, (body.key?(:error) ? body[:error] : response.status)
          end
        end
      end
    end
  end
end
