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

      include API::ResponseBuilder

      CONFIG_SETTINGS = %i{api_base_url api_path_prefix api_resource_key
                           api_resource_path api_search_path api_search_response_class}.freeze

      included do
        ##
        # [String] Base URL for all API requests for a class of resources. If
        #   present, replaces `Europeana::API.url`, for the one resource type.
        class_attribute :api_base_url

        ##
        # [String] Path prefix for all requests to a class of resources.
        class_attribute :api_path_prefix

        ##
        # [String] Hash key for one individual resource in a JSON response
        class_attribute :api_resource_key

        ##
        # [String] Tokenized API URL path for one individual resource
        class_attribute :api_resource_path

        ##
        # [String] Hash key for search results in a JSON response
        # class_attribute :api_search_key

        ##
        # [String] URL path to API search method for a resource
        class_attribute :api_search_path

        ##
        # [Class] Class for search responses
        #
        # Must respond to `.build_from_api_response` method
        class_attribute :api_search_response_class

        ##
        # API response
        attr_accessor :api_response
      end

      class_methods do
        ##
        # Configure class attributes
        #
        # @example
        #   class Europeana::Thing
        #     include Europeana::API::Resource
        #     configure_api do |things|
        #       things.path_prefix = '/stuff'
        #       things.resource_path = '/things/%{id}.json'
        #     end
        #   end
        def configure_api(&block)
          @defaults = block
          reset_api_config!
        end

        ##
        # Restores any config settings to their defaults
        def reset_api_config!
          CONFIG_SETTINGS.each do |attr|
            self.send(:"#{attr}=", nil)
          end

          @defaults.call(self) unless @defaults.nil?
        end

        ##
        # Gets one resource
        def fetch(**args)
          query_params = args.slice!(*extract_format_keys(api_resource_path))
          response = Europeana::API::Client.get(api_resource_url(args), **query_params)
          build_from_api_response(response)
        end

        ##
        # Searches for resources
        def search(**args)
          response = Europeana::API::Client.get(api_search_url, **args)
          if api_search_response_class.nil?
            response.body
          else
            api_search_response_class.build_from_api_response(response)
          end
        end

        def build_api_url(method_path)
          path = api_path_prefix + method_path

          if api_base_url.nil?
            path.sub(%r{\A/}, '') # remove leading slash for relative URLs
          else
            api_base_url + path
          end
        end

        def extract_format_keys(string)
          string.scan(/%\{(.*?)\}/).flatten.map(&:to_sym)
        end

        def api_resource_url(**args)
          build_api_url(format(api_resource_path, args))
        end

        def api_search_url
          build_api_url(api_search_path)
        end
      end
    end
  end
end
