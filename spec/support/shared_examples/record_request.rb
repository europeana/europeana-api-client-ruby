shared_examples 'record request' do
  let(:api_record_endpoint) { %r{www.europeana.eu/api/v2/record#{record_id}\.json} }
  let(:api_key) { 'xyz' }
  let(:record_id) { '/abc/1234' }
  let(:params) { { callback: 'doSomething();' } }

  before(:each) do
    stub_request(:get, api_record_endpoint).to_return(body: '{"success":true}')
    Europeana::API.api_key = api_key
  end

  it_behaves_like 'API request'

  it 'sends a Record request to the API' do
    subject
    expect(a_request(:get, api_record_endpoint)).to have_been_made.once
  end

  context 'when record ID is invalid' do
    it 'raises RequestError from HTML 404 response' do
      stub_request(:get, api_record_endpoint).
        to_return(body: '<html></html>', headers: { 'Content-Type' => 'text/html' }, status: 404)
      expect { subject }.to raise_error(Europeana::API::Errors::RequestError, "Invalid record identifier: #{record_id}")
    end
  end
end
