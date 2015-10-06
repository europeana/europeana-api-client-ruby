module Europeana
  module API
    class Record
      ##
      # Retrieve record hierarchies over the Europeana API
      class Hierarchy < HashWithIndifferentAccess
        include Requestable

        attr_reader :record_id

        ##
        # @param record [Europeana::API::Record]
        def initialize(record_id_or_hash)
          case record_id_or_hash
          when String
            @record_id = record_id_or_hash
            super(execute_request[:self])
          when Hash
            @record_id = record_id_or_hash[:id]
            super(record_id_or_hash)
          else
            fail ArgumentError, "Expected String or Hash, got #{record_id_or_hash.class}"
          end
        end

        def parent_id
          fetch(:parent, nil)
        end

        def has_parent?
          parent_id.present?
        end

        def parent
          @parent ||= has_parent? ? self.class.new(parent_id) : nil
        end

        def has_children?
          fetch(:hasChildren, false)
        end

        def children
          @children ||= has_children? ? fetch_group(:children) : []
        end

        def preceding_siblings
          @preceding_siblings ||= has_parent? ? fetch_group('preceeding-siblings') : []
        end
        alias_method :preceeding_siblings, :preceding_siblings

        def following_siblings
          @following_siblings ||= has_parent? ? fetch_group('following-siblings') : []
        end

        def fetch_group(rel)
          execute_request(rel: rel)[rel].map do |sibling|
            self.class.new(sibling)
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
          options.assert_valid_keys(:rel)
          Europeana::API.url + "/record#{@record_id}/#{options[:rel]}.json"
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
            raise Errors::RequestError, "Invalid record identifier: #{@record_id}"
          else
            raise
          end
        end
      end
    end
  end
end
