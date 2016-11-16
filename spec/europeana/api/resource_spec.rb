# frozen_string_literal: true
RSpec.describe Europeana::API::Resource do
  let(:resource_class) do
    Class.new do
      include Europeana::API::Resource
    end
  end

  it 'adds #has_api_endpoint class method' do
    expect(resource_class).to respond_to(:has_api_endpoint)
  end

  it 'adds #api_request_for_endpoint class method' do
    expect(resource_class).to respond_to(:api_request_for_endpoint)
  end

  it 'adds @api_endpoints class attribute accessor' do
    expect(resource_class).to respond_to(:api_endpoints)
  end

  describe '#has_api_endpoint' do
    it 'registers API endpoint method on class' do
      resource_class.has_api_endpoint(:fish, path: '/go/fish')
      expect(resource_class.api_endpoints).to have_key(:fish)
      expect(resource_class.api_endpoints[:fish]).to eq({ path: '/go/fish' })
      expect(resource_class).to respond_to(:fish)
    end

    it 'provides a means to make a request to the API' do
      resource_class.has_api_endpoint(:fish, path: '/go/fish')
      stub_request(:get, %r{://www.europeana.eu/api/go/fish}).
        to_return(status: 200, body: '{"catch":[]}', headers: { 'Content-Type' => 'application/json' })
      resource_class.fish(with: 'rod')
      expect(a_request(:get, %r{www.europeana.eu/api/go/fish})).to have_been_made.once
    end
  end

  describe '#api_request_for_endpoint' do
    it 'builds a request for the endpoint' do
      resource_class.has_api_endpoint(:fish, { path: '/go/fish' })
      request = resource_class.api_request_for_endpoint(:fish, with: 'rod')
      expect(request).to be_a(Europeana::API::Request)
      expect(request.params).to eq(with: 'rod')
      expect(request.endpoint).to eq(resource_class.api_endpoints[:fish])
    end
  end
end
