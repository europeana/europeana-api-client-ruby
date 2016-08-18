# frozen_string_literal: true
RSpec.describe Europeana::Resource do
  describe '.base_url' do
    it 'defaults to nil' do
      expect(described_class.base_url).to be_nil
    end

    it 'can be overriden in sub-classes' do
      class CustomResource < described_class
        self.base_url = 'http://api.example.com/'
      end
      expect(CustomResource.base_url).to eq('http://api.example.com/')
    end
  end
end