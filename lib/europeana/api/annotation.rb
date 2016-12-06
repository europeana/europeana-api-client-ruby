# frozen_string_literal: true
module Europeana
  module API
    ##
    # An annotation of a Europeana object
    #
    # @see http://labs.europeana.eu/api/annotations
    class Annotation
      include Resource

      has_api_endpoint :search, path: '/annotations/search'
      has_api_endpoint :fetch, path: '/annotations/%{provider}/%{id}'
      has_api_endpoint :create, method: :post, path: '/annotations/',
                                headers: { 'Content-Type' => 'application/ld+json' }
    end
  end
end
