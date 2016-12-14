# frozen_string_literal: true
module Europeana
  module API
    ##
    # Interface to the Entity API
    #
    # @see http://entity.europeana.eu/docs/
    class Entity
      include Resource

      has_api_endpoint :resolve, path: '/entities/resolve'
      has_api_endpoint :fetch, path: '/entities/%{type}/%{namespace}/%{identifier}'
      has_api_endpoint :suggest, path: '/entities/suggest'
    end
  end
end
