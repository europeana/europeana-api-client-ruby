# frozen_string_literal: true
require 'active_support/concern'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object'
require 'active_support/hash_with_indifferent_access'
require 'active_support/inflector/methods'
require 'europeana/api/version'
require 'europeana/api/logger'
require 'logger'
require 'uri'

module Europeana
  ##
  # Interface to Europeana's RESTful API(s)
  module API
    autoload :Annotation, 'europeana/api/annotation'
    autoload :Client, 'europeana/api/client'
    autoload :Errors, 'europeana/api/errors'
    autoload :FaradayMiddleware, 'europeana/api/faraday_middleware'
    autoload :Queue, 'europeana/api/queue'
    autoload :Record, 'europeana/api/record'
    autoload :Request, 'europeana/api/request'
    autoload :Resource, 'europeana/api/resource'
    autoload :Response, 'europeana/api/response'

    @url = 'https://www.europeana.eu/api'

    class << self
      ##
      # The Europeana API key, required for authentication
      #
      # @return [String]
      attr_accessor :key

      ##
      # The API's base URL
      #
      # @return [String]
      attr_accessor :url

      # @return [Logger]
      attr_writer :logger

      def logger
        @logger ||= defined?(Rails) && Rails.logger ? Rails.logger : Logger.new(STDOUT)
      end

      def in_parallel(&block)
        client = Client.new
        client.queue.instance_eval(&block)
        client.queue.run
      end

      def annotation
        Annotation
      end

      def record
        Record
      end
    end
  end
end
