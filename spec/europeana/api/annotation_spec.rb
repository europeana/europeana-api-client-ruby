# frozen_string_literal: true
RSpec.describe Europeana::API::Annotation do
  it_behaves_like 'a resource with API endpoint', :fetch
  it_behaves_like 'a resource with API endpoint', :search
  it_behaves_like 'a resource with API endpoint', :create

  before(:all) do
    Europeana::API.configure do |config|
      config.parse_json_to = OpenStruct
    end
  end

  after(:all) do
    Europeana::API.configure do |config|
      config.parse_json_to = Hash
    end
  end

  describe '.fetch' do
    before do
      stub_request(:get, %r{://www.europeana.eu/api/annotations/abc/123}).
        to_return(status: 200,
                  body: '{"@context":"https://www.w3.org/ns/anno.jsonld", "body":"Sheet music"}',
                  headers: { 'Content-Type' => 'application/ld+json' })
    end

    it 'requests an annotation from the API' do
      described_class.fetch(provider: 'abc', id: '123')
      expect(a_request(:get, %r{www.europeana.eu/api/annotations/abc/123})).to have_been_made.once
    end

    it 'returns the body of the response' do
      record = described_class.fetch(provider: 'abc', id: '123')
      expect(record).to be_an(OpenStruct)
      expect(record).to respond_to(:body)
    end
  end

  describe '.search' do
    before do
      stub_request(:get, %r{://www.europeana.eu/api/annotations/search}).
        to_return(status: 200,
                  body: '{"@context": "https://www.w3.org/ns/anno.jsonld", "items":[]}',
                  headers: { 'Content-Type' => 'application/ld+json' })
    end

    it 'requests an annotation search from the API' do
      described_class.search(query: '*:*')
      expect(a_request(:get, %r{www.europeana.eu/api/annotations/search})).to have_been_made.once
    end

    it 'returns the body of the response' do
      results = described_class.search(query: '*:*')
      expect(results).to be_an(OpenStruct)
      expect(results).to respond_to(:items)
    end
  end
end
