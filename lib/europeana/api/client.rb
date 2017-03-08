# frozen_string_literal: true
require 'europeana/api/faraday_middleware'
require 'typhoeus/adapters/faraday'

module Europeana
  module API
    ##
    # The API client responsible for handling requests and responses
    class Client
      attr_reader :queue

      delegate :get, :post, :put, :delete, :head, :patch, :options, to: :connection

      def initialize
        @queue = Queue.new(self)
      end

      def in_parallel?
        @queue.present?
      end

      ##
      # `Faraday` connection to the API
      #
      # * Requests are retried 5 times at an interval of 3 seconds
      # * Requests are instrumented
      # * JSON responses are parsed
      #
      # @return [Faraday::Connection]
      def connection
        @connection ||= begin
          Faraday.new do |conn|
            conn.request :instrumentation
            conn.request :parameter_repetition
            conn.request :authenticated_request
            conn.request :retry, max: 5, interval: 3,
                                 exceptions: [Errno::ECONNREFUSED, Errno::ETIMEDOUT, 'Timeout::Error',
                                              Faraday::Error::TimeoutError, EOFError]

            conn.response :json_various, content_type: /\bjson$/
            conn.response :text, content_type: %r{^text(\b[^/]+)?/(plain|html)$}

            conn.adapter :typhoeus
            conn.url_prefix = Europeana::API.url
          end
        end
      end
    end
  end
end
