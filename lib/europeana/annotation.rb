# frozen_string_literal: true
module Europeana
  ##
  # An annotation of a Europeana object
  #
  # @see http://labs.europeana.eu/api/annotations
  class Annotation < Resource
    configure do |annotations|
      annotations.path_prefix = '/annotations'
      annotations.resource_path = '/%{provider}/%{id}.jsonld'
    end
  end
end
