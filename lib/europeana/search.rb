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
      retries = Europeana.max_retries
      
      begin
        response = http.request(request)
      rescue Timeout::Error, Errno::ECONNREFUSED, EOFError
        retries -= 1
        raise unless retries > 0
        sleep Europeana.retry_delay
        retry
      end
      
      json = JSON.parse(response.body)
      raise Errors::RequestError, json['error'] unless json['success']
      json
    rescue JSON::ParserError
      raise Errors::ResponseError
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
    # Multiple `qf` parameters can be passed as a {Hash}:
    #
    #     Europeana::Search.new(:qf => { :what => "Photograph", :where => [ "Paris", "London" ] })
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
      request_params = params_with_authentication

      if request_params[:qf].is_a?(Hash)
        qf = request_params.delete(:qf)
        uri.query = request_params.to_query
        qf.each_pair do |name, criteria|
          [ criteria ].flatten.each do |criterion|
            uri.query = uri.query + "&qf=" + CGI::escape(name.to_s) + ":" + CGI::escape(criterion)
          end
        end
      else
        uri.query = request_params.to_query
      end
      
      Europeana.logger.debug("Europeana API request URL: #{uri.to_s}")
      uri
    end
  end
end
