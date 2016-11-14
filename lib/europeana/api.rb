# frozen_string_literal: true
require 'active_support/concern'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object'
require 'active_support/hash_with_indifferent_access'
require 'active_support/inflector/methods'
require 'europeana/api/version'
require 'europeana/api/logger'
require 'logger'
require 'uri'

module Europeana
  ##
  # Interface to Europeana's RESTful API(s)
  module API
    autoload :Annotation, 'europeana/api/annotation'
    autoload :FaradayMiddleware, 'europeana/api/faraday_middleware'
    autoload :Client, 'europeana/api/client'
    autoload :Endpoint, 'europeana/api/endpoint'
    autoload :Errors, 'europeana/api/errors'
    autoload :Record, 'europeana/api/record'
    autoload :Request, 'europeana/api/request'
    autoload :Resource, 'europeana/api/resource'

    class << self
      ##
      # The Europeana API key, required for authentication
      #
      # @return [String]
      attr_accessor :api_key

      ##
      # The API's base URL
      #
      # @return [String]
      attr_accessor :url

      ##
      # The maximum number of retries permitted
      #
      # Retries occur when a network request to the API fails. The default is 5
      # retries before giving up.
      #
      # @return [Integer]
      attr_accessor :max_retries

      ##
      # The number of seconds to wait between retries
      #
      # The default is 10 seconds.
      #
      # @return [Integer]
      attr_accessor :retry_delay

      # @return [Logger]
      attr_writer :logger

      attr_accessor :cache_store

      attr_accessor :cache_expires_in

      ##
      # Sets configuration values to their defaults
      def defaults!
        self.url = 'https://www.europeana.eu/api'
        self.max_retries = 5
        self.retry_delay = 3
      end

      def logger
        @logger ||= (defined?(Rails) && Rails.logger) ? Rails.logger : Logger.new(STDOUT)
      end
    end

    defaults!
  end
end
