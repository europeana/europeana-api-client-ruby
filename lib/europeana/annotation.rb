module Europeana
  ##
  # An annotation of a Europeana object
  #
  # @see http://labs.europeana.eu/api/annotations
  class Annotation < Resource
    self.base_url = 'https://www.europeana.eu/api/annotations'

    class << self
      def fetch(provider:, id:)
        get(resource_url(provider: provider, id: id))
      end

      def resource_url(**args)
        format "#{base_url}/%{provider}/%{id}.jsonld", args
      end
    end
  end
end
