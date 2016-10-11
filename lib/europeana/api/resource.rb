# frozen_string_literal: true
module Europeana
  module API
    ##
    # Base class for resources retrieved from the Europeana API
    class Resource < OpenStruct
      CONFIG_SETTINGS = %i{base_url resource_key resource_key resource_path search_path}.freeze

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
      # [Faraday::Response] API response used to construct this resource
      attr_accessor :_response

      class << self
        delegate :get, to: Europeana::API::Client

        ##
        # Configure class attributes
        #
        # @example
        #   class Europeana::Thing < Europeana::Resource
        #     configure do |things|
        #       things.path_prefix = '/stuff'
        #       things.resource_path
        #     end
        #   end
        def configure(&block)
          @defaults = block
          reset!
        end

        ##
        # Restores any config settings to their defaults
        def reset!
          CONFIG_SETTINGS.each do |attr|
            self.send(:"#{attr}=", nil)
          end

          @defaults.call(self) unless @defaults.nil?
        end

        ##
        # Gets one resource
        def fetch(**args)
          query_params = args.slice!(*extract_format_keys(resource_path))
          response = get(resource_url(args), **query_params)
          new(response.body)
        end

        ##
        # Searches for resources
        def search(**args)
          get(search_url, **args).body
        end

        def build_url(method_path)
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

        def resource_url(**args)
          build_url(format(resource_path, args))
        end

        def search_url
          build_url(search_path)
        end
      end
    end
  end
end
