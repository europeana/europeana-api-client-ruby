# frozen_string_literal: true
module Europeana
  module API
    ##
    # A queue of API requests to run in parallel
    class Queue
      Item = Struct.new(:resource, :method, :params)

      attr_reader :client

      def initialize(client)
        @client = client
        @items = []
      end

      def present?
        @items.present?
      end

      def add(resource, method, **params)
        @items << Item.new(resource, method, **params)
      end

      def run
        responses = []

        client.connection.in_parallel do
          @items.each do |item|
            resource_class = Europeana::API.send(item.resource)
            request = resource_class.send(:api_request_for_endpoint, item.method, item.params)
            request.client = client
            responses << request.execute
          end
        end

        responses.map do |response|
          begin
            response.validate!
            response.body
          rescue StandardError => exception
            exception
          end
        end
      end
    end
  end
end
