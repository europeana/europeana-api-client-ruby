require "europeana/version"
require "net/http"
require "uri"
require "active_support/core_ext/object"

module Europeana
  URL = 'http://www.europeana.eu/api/v2'
  
  autoload :Errors, 'europeana/errors'
  autoload :Record, 'europeana/record'
  autoload :Search, 'europeana/search'
  
  class << self
    ##
    # Sets the API key
    #
    # @param [String] api_key
    #
    def api_key=(api_key)
      @api_key = api_key
    end
    
    ##
    # Gets the API key
    #
    # @return [String]
    #
    def api_key
      @api_key
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
  end
  
end
