module Europeana
  module API
    class Record
      ##
      # Retrieve record hierarchies over the Europeana API
      class Hierarchy
        autoload :AncestorSelfSiblings, 'europeana/api/record/hierarchy/ancestor_self_siblings'
        autoload :Base, 'europeana/api/record/hierarchy/base'
        autoload :Children, 'europeana/api/record/hierarchy/children'
        autoload :FollowingSiblings, 'europeana/api/record/hierarchy/following_siblings'
        autoload :Parent, 'europeana/api/record/hierarchy/parent'
        autoload :PrecedingSiblings, 'europeana/api/record/hierarchy/preceding_siblings'
        autoload :Self, 'europeana/api/record/hierarchy/self'

        def initialize(id)
          @id = id
        end

        # bad idea having a method named self, but this is just a minimal
        # helper class, so going with it for consistency with the API
        def self(params = {})
          Self.new(@id, params).execute_request
        end

        def parent(params = {})
          Parent.new(@id, params).execute_request
        end

        def children(params = {})
          Children.new(@id, params).execute_request
        end

        def preceding_siblings(params = {})
          PrecedingSiblings.new(@id, params).execute_request
        end
        alias_method :preceeding_siblings, :preceding_siblings

        def following_siblings(params = {})
          FollowingSiblings.new(@id, params).execute_request
        end

        def ancestor_self_siblings(params = {})
          AncestorSelfSiblings.new(@id, params).execute_request
        end
      end
    end
  end
end
