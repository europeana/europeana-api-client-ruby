# frozen_string_literal: true
require 'spec_helper'

module Europeana
  module API
    module Errors
      describe MissingAPIKeyError do
        subject { described_class.new }

        it 'has an informative message' do
          expect(subject.message).to match('Missing API key.')
        end
      end

      describe RequestError do
        it 'has an informative message'
      end

      describe ResponseError do
        it 'has an informative message'
      end
    end
  end
end
