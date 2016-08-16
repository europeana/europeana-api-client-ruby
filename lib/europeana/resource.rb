# frozen_string_literal: true
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/module/delegation'

module Europeana
  ##
  # Base class for resources retrieved from the Europeana API
  class Resource
    include API::Requestable

    class << self
      delegate :get, to: Europeana::API::Client
    end

    ##
    # [String] Base URL for all API requests for a class of resources
    class_attribute :base_url
    self.base_url = 'https://www.europeana.eu/api'
  end
end
