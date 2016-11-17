# frozen_string_literal: true
module Europeana
  module API
    ##
    # Interface to the Europeana API Record method
    #
    # @see http://labs.europeana.eu/api/record/
    class Record
      include Resource

      has_api_endpoint :search,
                        path: '/v2/search.json',
                        errors: {
                          'Invalid query parameter' => Errors::RequestError,
                          /1000 search results/ => Errors::PaginationError
                        }
      has_api_endpoint :fetch, path: '/v2/record/%{id}.json'

      # Hierarchies
      %w(self parent children preceding_siblings following_siblings ancestor_self_siblings).each do |hierarchical|
        has_api_endpoint hierarchical.to_sym, path: "/v2/record/%{id}/#{hierarchical.dasherize}.json"
      end

      class << self
        ##
        # Escapes Lucene syntax special characters for use in query parameters.
        #
        # The `Europeana::API` gem does not perform this escaping itself.
        # Applications using the gem are responsible for escaping parameters
        # when needed.
        #
        # @param [String] text Text to escape
        # @return [String] Escaped text
        def escape(text)
          fail ArgumentError, "Expected String, got #{text.class}" unless text.is_a?(String)
          specials = %w<\\ + - & | ! ( ) { } [ ] ^ " ~ * ? : />
          specials.each_with_object(text.dup) do |char, unescaped|
            unescaped.gsub!(char, '\\\\' + char) # prepends *one* backslash
          end
        end
      end
    end
  end
end
