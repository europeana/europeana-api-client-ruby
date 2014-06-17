shared_examples "record request" do
  before(:all) do
    @api_key = "xyz"
    @record_id = "/abc/1234"
    @params = { :callback => "doSomething();" }
  end
  
  before(:each) do
    stub_request(:get, /www.europeana.eu\/api\/v2\/record#{@record_id}\.json/).to_return(:body => '{"success":true}')
  end
  
  it_behaves_like "API request"
  
  context "with API key" do
    before(:all) do
      Europeana.api_key = @api_key
    end
    
    it "sends a Record request to the API" do
      subject
      expect(a_request(:get, /www.europeana.eu\/api\/v2\/record#{@record_id}\.json/)).to have_been_made.once
    end
    
    context "when record ID is invalid" do
      it "raises RequestError from HTML 404 response" do
        stub_request(:get, /www.europeana.eu\/api\/v2\/record#{@record_id}\.json/).
          to_return(:body => '<html></html>', :headers => { 'Content-Type' => 'text/html' }, :status => 404)
        expect { subject }.to raise_error(Europeana::Errors::RequestError, "Invalid record identifier: #{@record_id}")
      end
    end
  end
end
