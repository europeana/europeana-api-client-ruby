require 'active_support/core_ext/object'
require 'active_support/hash_with_indifferent_access'
require 'europeana/api/version'
require 'logger'
require 'uri'

module Europeana
  ##
  # Europeana REST API client
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
      attr_accessor :max_retries

      ##
      # The number of seconds to wait between retries
      #
      # The default is 10 seconds.
      #
      # @return [Integer]
      attr_accessor :retry_delay

      ##
      # Sets configuration values to their defaults
      def defaults!
        self.max_retries = 5
        self.retry_delay = 10
      end

      ##
      # Sends a Search request to the Europeana API
      #
      # Equivalent to:
      #   search = Europeana::API::Search.new(params)
      #   search.execute
      #
      # @param [Hash] params Query parameters
      # @return [Hash] search response
      # @see Europeana::API::Search#execute
      def search(params = {})
        Search.new(params).execute
      end

      ##
      # Sends a Record request to the Europeana API
      #
      # Equivalent to:
      #   record = Europeana::API::Record.new(record_id, params)
      #   record.get(options)
      #
      # @param [String] Record ID
      # @param [Hash] params Query parameters
      # @param [Hash] options (see Europeana::API::Record#get)
      # @return [Hash] search response
      # @see Europeana::API::Record#get
      def record(record_id, params = {}, options = {})
        Record.new(record_id, params).get(options)
      end

      def logger
        return @logger unless @logger.nil?

        @logger = case
        when defined?(Rails) && Rails.logger
           Rails.logger
        else
          Logger.new(STDOUT).tap do |logger|
            logger.progname = 'Europeana::API'
          end
        end
      end
    end

    self.defaults!
  end
end
