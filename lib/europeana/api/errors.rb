# frozen_string_literal: true
module Europeana
  module API
    module Errors
      ##
      # Raised if API requests are attempted without the API key having been set.
      class MissingAPIKeyError < StandardError
      end

      ##
      # Raised if the API response success flag is false, indicating a problem
      # with the request.
      class RequestError < StandardError
      end

      class ResourceNotFoundError < StandardError
      end

      class ClientError < StandardError
      end

      class ServerError < StandardError
      end

      ##
      # Raised if the API response is not valid JSON.
      class ResponseError < StandardError
      end

      ##
      # Raised if the API response indicates invalid pagination params in
      # the request.
      class PaginationError < StandardError
      end
    end
  end
end
