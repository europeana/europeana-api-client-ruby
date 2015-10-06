require 'rubytree'
require 'active_support/core_ext/object/blank'

module Europeana
  module API
    class Record
      ##
      # Retrieve record hierarchies over the Europeana API
      class Hierarchy < Tree::TreeNode
        include Requestable

        attr_reader :record

        ##
        # @param record [Europeana::API::Record]
        def initialize(record)
          @record = record
          super(record.id, execute_request[:self])
          fetch_family
        end

        ##
        # Retrieves parent, children and siblings of this node
        def fetch_family
          unless content[:parent].blank?
            parent_response = execute_request(rel: :parent)[:parent]
            parent_node = Tree::TreeNode.new(parent_response[:id], parent_response)

            execute_request(rel: 'preceeding-siblings')['preceeding-siblings'].each do |sibling|
              parent_node << Tree::TreeNode.new(sibling[:id], sibling)
            end
            parent_node << self
            execute_request(rel: 'following-siblings')['following-siblings'].each do |sibling|
              parent_node << Tree::TreeNode.new(sibling[:id], sibling)
            end
          end

          if content[:hasChildren]
            children_response = execute_request(rel: :children)[:children]
            children_response.each do |child|
              self << Tree::TreeNode.new(child[:id], child)
            end
          end
        end

        ##
        # Gets the URL for a hierarchy request
        #
        # @param [Hash{Symbol => Object}] options
        # @option options [Symbol,String] :rel (:self)
        #   Relation to retrieve: {:self}, {:parent}, {"preceeding-siblings"},
        #   {"following-siblings"}, {:children}
        # @return [String]
        def request_url(options = {})
          options.reverse_merge!(rel: :self)
          Europeana::API.url + "/record#{@record.id}/#{options[:rel]}.json"
        end

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
            fail Errors::RequestError, body[:message] unless body[:success]
          end
        rescue JSON::ParserError
          if response.code.to_i == 404
            # Handle HTML 404 responses on malformed record ID, emulating API's
            # JSON response.
            raise Errors::RequestError, "Invalid record identifier: #{@record.id}"
          else
            raise
          end
        end
      end
    end
  end
end
