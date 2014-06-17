shared_examples "record request" do
  before(:all) do
    @api_key = "xyz"
    @record_id = "/abc/1234"
    @params = { :callback => "doSomething();" }
  end
  
  before(:each) do
    stub_request(:get, /www.europeana.eu\/api\/v2\/record#{@record_id}\.json/).to_return(:body => '{"success":true}')
  end
  
  context "without API key" do
    before(:each) do
      Europeana.api_key = nil
    end
    
    it "sends no HTTP request" do
      begin
        subject
      rescue Europeana::Errors::MissingAPIKeyError
      end
      expect(a_request(:get, /www.europeana.eu\/api\/v2\//)).not_to have_been_made
    end
  end
  
  context "with API key" do
    before(:all) do
      Europeana.api_key = @api_key
    end
    
    it "sends a Record request to the API" do
      subject
      expect(a_request(:get, /www.europeana.eu\/api\/v2\/record#{@record_id}\.json/)).to have_been_made.once
    end
    
    it "returns the response as a Hash" do
      response = subject
      expect(response).to be_a(Hash)
    end
    
    context "when the API is unavailable" do
      before(:each) do
        Europeana.retry_delay = 0
      end
      
      it "waits then retries" do
        stub_request(:get, /www.europeana.eu\/api\/v2\/record#{@record_id}\.json/).
          to_timeout.times(1).then.
          to_return(:body => '{"success":true}')
        subject
        expect(a_request(:get, /www.europeana.eu\/api\/v2\/record#{@record_id}\.json/)).to have_been_made.times(2)
      end
    end
  end
end
