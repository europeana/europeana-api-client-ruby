# frozen_string_literal: true
module Europeana
  class Annotation
    ##
    # A page of annotations of a Europeana object
    #
    # @see https://www.w3.org/TR/annotation-model/#annotation-page
    class Page
      include API::ResponseBuilder

      has_api_response_properties :id, :items, :next, :partOf, :prev, :total, :type
    end
  end
end
