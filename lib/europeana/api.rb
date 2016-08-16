require 'active_support/cache'
require 'active_support/core_ext/object'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/slice'
require 'active_support/hash_with_indifferent_access'
require 'active_support/inflector/methods'
require 'europeana/api/version'
require 'logger'
require 'uri'

module Europeana
  autoload :Record, 'europeana/record'

  ##
  # Europeana REST API client
  module API
    autoload :Errors, 'europeana/api/errors'
    autoload :Request, 'europeana/api/request'
    autoload :Requestable, 'europeana/api/requestable'

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
        self.url = 'https://www.europeana.eu/api/v2'
        self.max_retries = 5
        self.retry_delay = 10
        self.cache_store = ActiveSupport::Cache::NullStore.new
        self.cache_expires_in = 24.hours
      end

      ##
      # Sends a Record request to the Europeana API
      #
      # Equivalent to:
      #   record = Europeana::Record.new(record_id, params)
      #   record.fetch(options)
      #
      # @param [String] Record ID
      # @param [Hash] params Query parameters
      # @param [Hash] options (see Europeana::API::Record#get)
      # @return [Hash] search response
      # @see Europeana::API::Record#get
      def record(record_id, params = {}, options = {})
        Record.new(record_id, params).fetch(options)
      end

      def logger
        @logger ||= (defined?(Rails) && Rails.logger) ? Rails.logger : Logger.new(STDOUT)
      end
    end

    self.defaults!
  end
end
