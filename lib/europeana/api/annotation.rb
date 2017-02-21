# frozen_string_literal: true
module Europeana
  module API
    ##
    # An annotation of a Europeana object
    #
    # @see http://labs.europeana.eu/api/annotations
    class Annotation
      include Resource

      has_api_endpoint :search, method: :get, path: '/annotations/search'
      has_api_endpoint :fetch, method: :get, path: '/annotations/%{provider}/%{id}'
      has_api_endpoint :create, method: :post, path: '/annotations/',
                                headers: { 'Content-Type' => 'application/ld+json' }
      has_api_endpoint :update, method: :put, path: '/annotations/%{provider}/%{id}',
                                headers: { 'Content-Type' => 'application/ld+json' }
      has_api_endpoint :delete, method: :delete, path: '/annotations/%{provider}/%{id}'
    end
  end
end
