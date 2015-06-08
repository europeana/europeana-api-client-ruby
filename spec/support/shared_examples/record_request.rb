shared_examples "record request" do
  before(:each) do
    stub_request(:get, /www.europeana.eu\/api\/v2\/record#{record_id}\.json/).
      to_return(body: '{"success":true}')
  end

  it_behaves_like "API request"

  context "with API key" do
    before(:each) do
      Europeana::API.api_key = api_key
    end

    let(:api_key) { 'xyz' }
    let(:record_id) { '/abc/1234' }
    let(:params) { { callback: 'doSomething();' } }

    it "sends a Record request to the API" do
      subject
      expect(a_request(:get, /www.europeana.eu\/api\/v2\/record#{record_id}\.json/)).to have_been_made.once
    end

    context "when record ID is invalid" do
      it "raises RequestError from HTML 404 response" do
        stub_request(:get, /www.europeana.eu\/api\/v2\/record#{record_id}\.json/).
          to_return(body: '<html></html>', headers: { 'Content-Type' => 'text/html' }, status: 404)
        expect { subject }.to raise_error(Europeana::API::Errors::RequestError, "Invalid record identifier: #{record_id}")
      end
    end
  end
end
