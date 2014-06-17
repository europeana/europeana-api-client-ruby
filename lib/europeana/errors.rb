module Europeana
  module Errors
    ##
    # Raised if API requests are attempted without the API key having been set.
    #
    class MissingAPIKeyError < StandardError
       def initialize(msg = nil)
        msg ||= <<-MSG
Missing API key.

The Europeana API key has not been set.

Sign up for an API key at: http://labs.europeana.eu/api/registration/

Set the key with:

  Europeana.api_key = "xyz"
        MSG
        super(msg)
       end
    end
    
    ##
    # Raised if the API response success flag is false, indicating a problem
    # with the request.
    #
    class RequestError < StandardError
      def initialize(msg = nil)
        msg ||= <<-MSG
Request error.

There was a problem with your request to the API.
        MSG
        super(msg)
       end
    end
  end
end
