# frozen_string_literal: true
require 'active_support/core_ext/class/attribute'

module Europeana
  ##
  # Base class for resources retrieved from the Europeana API
  class Resource
    include API::Requestable

    ##
    # [String] Base URL for all API requests for a class of resources
    class_attribute :base_url
    self.base_url = 'https://www.europeana.eu/api'

    class << self
      def request(url:, params: {})
        params.reverse_merge!(wskey: Europeana::API.api_key)
        API::Client.request(url: url, params: params)
      end
    end
  end
end
