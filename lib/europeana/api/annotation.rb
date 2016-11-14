# frozen_string_literal: true
module Europeana
  module API
    ##
    # An annotation of a Europeana object
    #
    # @see http://labs.europeana.eu/api/annotations
    # @see https://www.w3.org/TR/annotation-model/#annotations
    class Annotation
      autoload :Page, 'europeana/api/annotation/page'

      include Resource

      configure_api do |annotations|
        annotations.api_path_prefix = '/annotations'
        annotations.api_resource_path = '/%{provider}/%{id}.jsonld'
        annotations.api_search_path = '/search.jsonld'
        annotations.api_search_response_class = Page
      end

      has_api_response_properties :body, :created, :creator, :generated,
                                  :generator, :id, :motivation, :target, :type

      def record_id
        fail %W(target is not a Europeana record: "#{target}") \
          unless target.start_with?('http://data.europeana.eu/item/')

        target.sub(%r{\Ahttp://data.europeana.eu/item}, '')
      end

      def record
        @record ||= Record.fetch(id: record_id)
      end
    end
  end
end
