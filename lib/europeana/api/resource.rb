# frozen_string_literal: true
module Europeana
  module API
    ##
    # Module for resources retrieved from the Europeana API
    module Resource
      extend ActiveSupport::Concern

      included do
        class_attribute :api_endpoints
      end

      class_methods do
        # @todo path is not optional; ensure that it exists
        def has_api_endpoint(name, **options)
          self.api_endpoints ||= {}
          self.api_endpoints[name] = options

          define_singleton_method(name) do |**params|
            api_request_for_endpoint(name, **params).execute
          end
        end

        def api_request_for_endpoint(name, **params)
          Request.new(self.api_endpoints[name], **params)
        end
      end
    end
  end
end
