# frozen_string_literal: true
module Europeana
  ##
  # Interface to the Europeana API Record method
  #
  # @see http://labs.europeana.eu/api/record/
  class Record
    include API::Resource

    autoload :Hierarchy, 'europeana/record/hierarchy'

    configure_api do |records|
      records.path_prefix = '/v2'
      records.resource_path = '/record/%{id}.json'
      records.resource_key = 'object'
      records.search_path = '/search.json'
      records.search_key = 'items'
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
        specials = %w<\\ + - & | ! ( ) { } [ ] ^ " ~ * ? : / >
        specials.each_with_object(text.dup) do |char, unescaped|
          unescaped.gsub!(char, '\\\\' + char) # prepends *one* backslash
        end
      end
    end

# Old `Record` methods to be ported follow

#     def hierarchy
#       @hierarchy ||= Hierarchy.new(id)
#     end

# Old `Search methods to be ported` follow

#       ##
#       # Examines the `success` and `error` fields of the response for failure
#       #
#       # @raise [Europeana::Errors::RequestError] if API response has
#       #   `success:false`
#       # @see Requestable#parse_response
#       def parse_response(response, _options = {})
#         super.tap do |body|
#           unless body[:success]
#             klass = if body.key?(:error) && body[:error] =~ /1000 search results/
#                       API::Errors::Request::PaginationError
#                     else
#                       API::Errors::RequestError
#                     end
#             fail klass, (body.key?(:error) ? body[:error] : response.status)
#           end
#         end
#       end
  end
end
