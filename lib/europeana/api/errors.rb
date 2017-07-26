# frozen_string_literal: true
module Europeana
  module API
    module Errors
      class Base < StandardError
        attr_reader :faraday_response

        def initialize(faraday_response)
          @faraday_response = faraday_response
        end
      end

      ##
      # Raised if API requests are attempted without the API key having been set.
      class MissingAPIKeyError < Base
      end

      ##
      # Raised if the API response success flag is false, indicating a problem
      # with the request.
      class RequestError < Base
      end

      class ResourceNotFoundError < Base
      end

      class ClientError < Base
      end

      class ServerError < Base
      end

      ##
      # Raised if the API response is not valid JSON.
      class ResponseError < Base
      end

      ##
      # Raised if the API response indicates invalid pagination params in
      # the request.
      class PaginationError < Base
      end
    end
  end
end
