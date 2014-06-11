module Europeana
  ##
  # Interface to Europeana API's Search method
  #
  class Search
    # Query params
    attr_accessor :params
    
    ##
    # @param [Hash] params Europeana API request parameters for Search query
    # @see #params=
    #
    def initialize(params = {})
      self.params = params
    end
    
    ##
    # Sends the Search request to the API
    #
    def execute
      uri = request_uri
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      JSON.parse(response.body)
    end
    
    ##
    # Returns query params with API key added
    #
    # @return [Hash]
    #
    def params_with_authentication
      raise Europeana::Errors::MissingAPIKeyError unless Europeana.api_key.present?
      params.merge(:wskey => Europeana.api_key).reverse_merge(:query => "")
    end
    
    ##
    # Sets request parameters after validating keys
    #
    # Valid parameter keys:
    # * :query
    # * :profile
    # * :qf
    # * :rows
    # * :start
    # * :callback
    #
    # For explanations of these request parameters, see: http://labs.europeana.eu/api/search/
    #
    # @param (see #initialize)
    # @return [Hash] Passed params, if valid
    #
    def params=(params = {})
      params.assert_valid_keys(:query, :profile, :qf, :rows, :start, :callback)
      @params = params
    end
    
    ##
    # Gets the URI for this Search request with parameters
    #
    # @return [URI]
    #
    def request_uri
      uri = URI.parse(Europeana::URL + "/search.json")
      uri.query = params_with_authentication.to_query
      uri
    end
  end
end
