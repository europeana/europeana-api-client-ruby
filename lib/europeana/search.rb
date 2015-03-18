module Europeana
  ##
  # Interface to Europeana API's Search method
  class Search
    # Query params
    attr_accessor :params

    ##
    # @param [Hash] params Europeana API request parameters for Search query
    def initialize(params = {})
      @params = HashWithIndifferentAccess.new(params)
    end

    ##
    # Sends the Search request to the API
    #
    # @return [HashWithIndifferentAccess]
    # @raise [Europeana::Errors::ResponseError] if API response could not be
    #   parsed as JSON
    # @raise [Europeana::Errors::RequestError] if API response has
    #   `success:false`
    def execute
      request = Europeana::Request.new(request_uri)
      response = request.execute
      body = JSON.parse(response.body)
      fail Errors::RequestError, body['error'] unless body['success']
      HashWithIndifferentAccess.new(body)
    rescue JSON::ParserError
      raise Errors::ResponseError
    end

    ##
    # Returns query params with API key added
    #
    # @return [Hash]
    def params_with_authentication
      return params if params.key?(:wskey)
      unless Europeana.api_key.present?
        fail Europeana::Errors::MissingAPIKeyError
      end
      params.merge(wskey: Europeana.api_key)
    end

    ##
    # Gets the URI for this Search request with parameters
    #
    # @return [URI]
    def request_uri
      uri = URI.parse(Europeana::URL + '/search.json')
      uri.query = request_uri_query
      uri
    end

    def request_uri_query
      uri_query = ''
      params_with_authentication.each_pair do |name, value|
        [value].flatten.each do |v|
          uri_query << '&' unless uri_query.blank?
          uri_query << CGI.escape(name.to_s) + '=' + CGI.escape(v.to_s)
        end
      end
      uri_query
    end
  end
end
