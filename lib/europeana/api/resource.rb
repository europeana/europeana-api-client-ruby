# frozen_string_literal: true
module Europeana
  module API
    ##
    # Base class for resources retrieved from the Europeana API
    module Resource
      extend ActiveSupport::Concern

      CONFIG_SETTINGS = %i{base_url resource_key resource_key resource_path search_path}.freeze

      included do
        ##
        # [String] Base URL for all API requests for a class of resources. If
        #   present, replaces `Europeana::API.url`, for the one resource type.
        class_attribute :base_url

        ##
        # [String] Path prefix for all requests to a class of resources.
        class_attribute :path_prefix

        ##
        # [String] Hash key for one individual resource in a JSON response
        class_attribute :resource_key

        ##
        # [String] Tokenized API URL path for one individual resource
        class_attribute :resource_path

        ##
        # [String] Hash key for search results in a JSON response
        class_attribute :search_key

        ##
        # [String] URL path to API search method for a resource
        class_attribute :search_path

        ##
        # API response
        attr_accessor :response
      end

      class_methods do
        def new_from_api_response(response)
          resource = new
          resource.response = response
          resource
        end

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
          query_params = args.slice!(*extract_format_keys(resource_path))
          response = Europeana::API::Client.get(resource_api_url(args), **query_params)
          new_from_api_response(response)
        end

        ##
        # Searches for resources
        def search(**args)
          Europeana::API::Client.get(search_api_url, **args).body
        end

        def build_api_url(method_path)
          path = path_prefix + method_path

          if base_url.nil?
            path.sub(%r{\A/}, '') # remove leading slash for relative URLs
          else
            base_url + path
          end
        end

        def extract_format_keys(string)
          string.scan(/%\{(.*?)\}/).flatten.map(&:to_sym)
        end

        def resource_api_url(**args)
          build_api_url(format(resource_path, args))
        end

        def search_url
          build_api_url(search_path)
        end
      end
    end
  end
end
