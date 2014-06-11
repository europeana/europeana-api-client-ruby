require "net/http"
require "uri"
require "active_support/core_ext/object"

module Europeana
  class Search
    attr_accessor :params
    
    ##
    # @param [Hash] params Europeana API request parameters for Search query
    #
    def initialize(params = {})
      @params = params
    end
    
    ##
    # Sends the Search request to the API
    #
    def execute
      uri = URI.parse(Europeana::URL + "/search.json")
      uri.query = params_with_authentication.to_query
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      JSON.parse(response.body)
    end
    
    def params_with_authentication
      raise Europeana::Errors::MissingAPIKeyError unless Europeana.api_key.present?
      params.merge(:wskey => Europeana.api_key).reverse_merge(:query => "")
    end
  end
end
