module Europeana
  ##
  # Interface to the Europeana API Record method
  #
  # @see http://labs.europeana.eu/api/record/
  #
  class Record
    # Europeana ID of the record
    attr_accessor :id
    
    # Request parameters to send to the API
    attr_accessor :params
    
    ##
    # @param [String] id Europeana ID of the record
    # @param [Hash] params Request parameters
    #
    def initialize(id, params = {})
      self.id = id
      self.params = params
      @hierarchy = HashWithIndifferentAccess.new
    end
    
    ##
    # Returns query params with API key added
    #
    # @return [Hash]
    #
    def params_with_authentication
      raise Europeana::Errors::MissingAPIKeyError unless Europeana.api_key.present?
      params.merge(:wskey => Europeana.api_key)
    end
    
    ##
    # Sets record ID attribute after validating format.
    #
    # @param [String] id Record ID
    #
    def id=(id)
      unless id.is_a?(String) && id.match(/\A\/[^\/]+\/[^\/]+\B/)
        fail ArgumentError, "Invalid Europeana record ID: \"#{id.to_s}\""
      end
      @id = id
    end
    
    ##
    # Sets request parameters after validating keys
    #
    # Valid parameter keys:
    # * :callback
    #
    # For explanations of these request parameters, see: http://labs.europeana.eu/api/record/
    #
    # @param (see #initialize)
    # @return [Hash] Request parameters
    #
    def params=(params = {})
      params.assert_valid_keys(:callback)
      @params = params
    end
    
    ##
    # Gets the URI for this Record request with parameters
    #
    # @return [URI]
    #
    def request_uri
      uri = URI.parse(Europeana::URL + "/record" + "#{@id}.json")
      uri.query = params_with_authentication.to_query
      uri
    end
    
    ##
    # Sends a request for this record to the API
    #
    # @return [HashWithIndifferentAccess]
    # @raise [Europeana::Errors::ResponseError] if API response could not be
    #   parsed as JSON
    # @raise [Europeana::Errors::RequestError] if API response has `success:false`
    # @raise [Europeana::Errors::RequestError] if API response has 404 status code
    #
    def get
      request = Europeana::Request.new(request_uri)
      response = request.execute
      body = JSON.parse(response.body)
      raise Errors::RequestError, body['error'] unless body['success']
      HashWithIndifferentAccess.new(body)
    rescue JSON::ParserError
      if response.code.to_i == 404
        # Handle HTML 404 responses on malformed record ID, emulating API's
        # JSON response.
        raise Errors::RequestError, "Invalid record identifier: #{@id}"
      else
        raise Errors::ResponseError
      end
    end
    
    ##
    # Gets hierarchy data about this and related records from 
    # ancestor-self-siblings.json API method
    #
    # @note Proof of concept implementation for demo purposes.
    # @todo Refactor if functionality to be retained.
    #
    def hierarchy(*args)
      args = [ :self ] if args.blank?
      
      data = {}
      args.each do |method|
        unless @hierarchy.has_key?(method)
          @hierarchy[method] = hierarchical_data(method).select { |k, v| v.is_a?(Enumerable) }
        end
        data.merge!(@hierarchy[method])
      end
      data
    end
    
    def hierarchical_data(method = :self)
      request = Request.new(hierarchical_data_uri(method))
      response = request.execute
      body = JSON.parse(response.body)
      raise Errors::RequestError, body['message'] unless body['success']
      body
    rescue JSON::ParserError
      if response.code.to_i == 404
        # Handle HTML 404 responses on malformed record ID, emulating API's
        # JSON response.
        raise Errors::RequestError, "Invalid record identifier: #{@id}"
      else
        raise Errors::ResponseError
      end
    end
    
    def hierarchical_data_uri(method = :self)
      uri = URI.parse(Europeana::URL + "/record" + "#{@id}/#{method.to_s}.json")
      uri.query = params_with_authentication.to_query
      uri
    end
  end
end
