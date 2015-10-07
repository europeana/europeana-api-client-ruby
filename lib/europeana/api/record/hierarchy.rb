module Europeana
  module API
    class Record
      ##
      # Retrieve record hierarchies over the Europeana API
      class Hierarchy < HashWithIndifferentAccess
        include Requestable

        attr_reader :record_id, :params

        ##
        # @param record [Europeana::API::Record]
        def initialize(record_id_or_hash)
          @params = {}

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

        alias_method :get, :execute_request

        def parent_id
          fetch(:parent, nil)
        end

        def has_parent?
          parent_id.present?
        end

        def parent(_options = {})
          @parent ||= has_parent? ? self.class.new(parent_id) : nil
        end

        def has_children?
          fetch(:hasChildren, false)
        end

        def children(options = {})
          @children ||= has_children? ? fetch_group(:children, options) : []
        end

        def preceding_siblings(options = {})
          @preceding_siblings ||= has_parent? ? fetch_group('preceeding-siblings', options) : []
        end
        alias_method :preceeding_siblings, :preceding_siblings

        def following_siblings(options = {})
          @following_siblings ||= has_parent? ? fetch_group('following-siblings', options) : []
        end

        # @param relation [String,Symbol] Relation to retrieve:
        #   {"preceeding-siblings"}, {"following-siblings"}, {:children}
        # @param params [Hash{Symbol => Object}] Additional Hierarchy API query params
        # @option options [Fixnum] :offset First relative to retrieve
        # @option options [Fixnum] :limit Number of relatives to retrieve
        def fetch_group(relation, params = {})
          @params = params
          execute_request(relation: relation)[relation].map do |relative|
            self.class.new(relative)
          end
        end

        def with_family
          parent
          children
          preceding_siblings
          following_siblings
          self
        end

        ##
        # Gets the URL for a hierarchy request
        #
        # @param options [Hash{Symbol => Object}]
        # @option options [Symbol,String] :relation (:self)
        #   Relation to retrieve: {:self}, {:parent}, {"preceeding-siblings"},
        #   {"following-siblings"}, {:children}
        # @return [String]
        def request_url(options = {})
          options.reverse_merge!(relation: :self)
          options.assert_valid_keys(:relation)
          Europeana::API.url + "/record#{@record_id}/#{options[:relation]}.json"
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
            unless body[:success]
              if body[:error] && body[:error].match(/Invalid record identifier/)
                {}
              else
                fail Errors::RequestError, body[:message]
              end
            end
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

        def as_json(options = {})
          options.reverse_merge!(family: true)
          return super(options) unless options.delete(:family)

          { self: super(options) }.tap do |json|
            json[:parent] = @parent.as_json(family: false) unless @parent.nil?
            [:children, :following_siblings, :preceding_siblings].each do |relation|
              relatives = instance_variable_get(:"@#{relation}")
              json[relation] = relatives.map { |relative| relative.as_json(family: false) } unless relatives.blank?
            end
          end
        end
      end
    end
  end
end
