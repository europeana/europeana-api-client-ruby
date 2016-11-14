# frozen_string_literal: true
module Europeana
  module API
    ##
    # Module for resources retrieved from the Europeana API
    #
    # All classes including this are expected to implement a factory method
    # named `.build_from_api_response` accepting the `Faraday::Response` object
    # as its single parameter.
    module Resource
      extend ActiveSupport::Concern

      included do
        class_attribute :api_endpoints
      end

      class_methods do
        def has_api_endpoint(name, **options)
          self.api_endpoints ||= {}
          self.api_endpoints[name] = options.reverse_merge(class: self)

          define_singleton_method(name) do |**params|
            endpoint = self.api_endpoints[name]
            Request.new(endpoint, **params).execute
          end
        end
      end
    end
  end
end
