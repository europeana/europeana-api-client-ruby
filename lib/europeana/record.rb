# frozen_string_literal: true
module Europeana
  ##
  # Interface to the Europeana API Record method
  #
  # @see http://labs.europeana.eu/api/record/
  class Record < API::Resource
    autoload :Hierarchy, 'europeana/record/hierarchy'

    configure do |records|
      records.path_prefix = '/v2'
      records.resource_path = '/record/%{id}.json'
      records.resource_key = 'object'
      records.search_path = '/search.json'
      records.search_key = 'items'
    end

# Old `Record` methods to be ported follow

#     ##
#     # Sets record ID attribute after validating format.
#     #
#     # @param [String] id Record ID
#     #
#     def id=(id)
#       unless id.is_a?(String) && id.match(%r{\A/[^/]+/[^/]+\B})
#         fail ArgumentError, "Invalid Europeana record ID: \"#{id}\""
#       end
#       @id = id
#     end

#     ##
#     # Sets request parameters after validating keys
#     #
#     # Valid parameter keys:
#     # * :callback
#     #
#     # For explanations of these request parameters, see: http://labs.europeana.eu/api/record/
#     #
#     # @param (see #initialize)
#     # @return [Hash] Request parameters
#     def params=(params = {})
#       params.assert_valid_keys(:callback, :wskey)
#       @params = params
#     end

#     ##
#     # Examines the `success` and `error` fields of the response for failure
#     #
#     # @raise [Europeana::Errors::RequestError] if API response has
#     #   `success:false`
#     # @raise [Europeana::Errors::RequestError] if API response has 404 status
#     #   code
#     # @see Requestable#parse_response
#     def parse_response(response, options = {})
#       super.tap do |body|
#         if (options[:ld] && !response.success?) || (!options[:ld] && !body[:success])
#           fail API::Errors::RequestError, (body.key?(:error) ? body[:error] : response.status)
#         end
#       end
#     rescue JSON::ParserError
#       if response.status == 404
#         # Handle HTML 404 responses on malformed record ID, emulating API's
#         # JSON response.
#         raise API::Errors::RequestError, "Invalid record identifier: #{@id}"
#       else
#         raise
#       end
#     end

#     def hierarchy
#       @hierarchy ||= Hierarchy.new(id)
#     end

# Old `Search methods to be ported` follow

#       class << self
#         ##
#         # Escapes Lucene syntax special characters for use in query parameters.
#         #
#         # The `Europeana::API` gem does not perform this escaping itself.
#         # Applications using the gem are responsible for escaping parameters
#         # when needed.
#         #
#         # @param [String] text Text to escape
#         # @return [String] Escaped text
#         def escape(text)
#           fail ArgumentError, "Expected String, got #{text.class}" unless text.is_a?(String)
#           specials = %w<\\ + - & | ! ( ) { } [ ] ^ " ~ * ? : / >
#           specials.each_with_object(text.dup) do |char, unescaped|
#             unescaped.gsub!(char, '\\\\' + char) # prepends *one* backslash
#           end
#         end
#       end

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
