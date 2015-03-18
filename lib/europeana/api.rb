require 'europeana/api/version'
require 'uri'
require 'logger'
require 'active_support/core_ext/object'
require 'active_support/hash_with_indifferent_access'

##
# Europeana REST API client
module Europeana
  module API
    API_VERSION = 'v2'
    URL = "http://www.europeana.eu/api/#{API_VERSION}"

    autoload :Errors,   'europeana/api/errors'
    autoload :Record,   'europeana/api/record'
    autoload :Request,  'europeana/api/request'
    autoload :Search,   'europeana/api/search'

    class << self
      # The Europeana API key, required for authentication
      attr_accessor :api_key

      ##
      # The maximum number of retries permitted
      #
      # Retries occur when a network request to the API fails. The default is 5
      # retries before giving up.
      #
      # @return [Integer]
      #
      attr_accessor :max_retries

      ##
      # The number of seconds to wait between retries
      #
      # The default is 10 seconds.
      #
      # @return [Integer]
      #
      attr_accessor :retry_delay

      ##
      # Sets configuration values to their defaults
      #
      def defaults!
        self.max_retries = 5
        self.retry_delay = 10
      end

      ##
      # Sends a Search request to the Europeana API
      #
      # Equivalent to:
      #   search = Europeana::Search.new(params)
      #   search.execute
      #
      # @param [Hash] params Query parameters
      # @return [Hash] search response
      # @see Europeana::Search#execute
      #
      def search(params = {})
        Search.new(params).execute
      end

      ##
      # Sends a Record request to the Europeana API
      #
      # Equivalent to:
      #   search = Europeana::Record.new(record_id, params)
      #   record.get
      #
      # @param [String] Record ID
      # @param [Hash] params Query parameters
      # @return [Hash] search response
      # @see Europeana::Record#get
      #
      def record(record_id, params = {})
        Record.new(record_id, params).get
      end

      def logger
        unless @logger
          if defined?(Rails) && Rails.logger
            @logger = Rails.logger
          else
            @logger = Logger.new(STDOUT)
          end
        end
        @logger
      end
    end

    self.defaults!
  end
end
