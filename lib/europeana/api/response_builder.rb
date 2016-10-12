# frozen_string_literal: true
module Europeana
  module API
    ##
    # Build a model from an API response.
    module ResponseBuilder
      extend ActiveSupport::Concern

      included do
        attr_accessor :api_response

        ##
        # [Array] Names of properties to read from API response.
        #
        # Object attributes will have underscored names, e.g. `"partOf"` in an
        # API response will become `#part_of` on the object.
        class_attribute :api_response_properties
      end

      class_methods do
        def has_api_response_properties(*properties)
          self.api_response_properties = properties

          properties.each do |property|
            attr_accessor property.to_s.underscore.to_sym
          end
        end

        def build_from_api_response(response)
          new.tap do |object|
            object.api_response = response
            body = self.api_resource_key.nil? ? response.body : response.body[self.api_resource_key]
            (self.api_response_properties || []).each do |property|
              attr_name = property.to_s.underscore
              object.send("#{attr_name}=", body[property.to_s])
            end
          end
        end
      end
    end
  end
end
