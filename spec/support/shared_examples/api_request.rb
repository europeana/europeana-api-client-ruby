shared_examples "API request" do
  context "without API key" do
    before(:each) do
      Europeana.api_key = nil
    end
    
    it "sends no HTTP request" do
      begin
        subject
      rescue Europeana::Errors::MissingAPIKeyError
      end
      expect(a_request(:get, /www.europeana.eu\/api\/v2/)).not_to have_been_made
    end
  end
  
  context "with API key" do
    before(:all) do
      Europeana.api_key = "xyz"
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
        stub_request(:get, /www.europeana.eu\/api\/v2/).
          to_timeout.times(1).then.
          to_return(:body => '{"success":true}')
        subject
        expect(a_request(:get, /www.europeana.eu\/api\/v2/)).to have_been_made.times(2)
      end
    end
    
    context "when API response is unsuccessful" do
      it "raises a RequestError" do
        stub_request(:get, /www.europeana.eu\/api\/v2/).to_return(:body => '{"success":false,"error":"Something went wrong"}')
        expect { subject }.to raise_error(Europeana::Errors::RequestError, "Something went wrong")
      end
    end
    
    context "when API response is invalid JSON" do
      it "raises a ResponseError" do
        stub_request(:get, /www.europeana.eu\/api\/v2/).to_return(:body => 'invalid JSON')
        expect { subject }.to raise_error(Europeana::Errors::ResponseError)
      end
    end
  end
end


