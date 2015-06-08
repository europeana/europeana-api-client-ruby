shared_examples "search request" do
  before(:each) do
    stub_request(:get, %r{www.europeana.eu/api/v2/search.json}).
      to_return(body: '{"success":true}')
  end

  it_behaves_like "API request"

  context "with API key" do
    let(:api_key) { 'xyz' }
    let(:params) { {} }

    before do
      Europeana::API.api_key = api_key
    end

    it "sends a Search request to the API" do
      subject
      expect(a_request(:get, %r{www.europeana.eu/api/v2/search.json})).
        to have_been_made.once
    end

    context "without query" do
      it "sets an empty query" do
        subject
        expect(a_request(:get, %r{www.europeana.eu/api/v2/search.json?query=})).
          to have_been_made.once
      end
    end

    context "with query" do
      let(:params) { { query: 'test' } }

      it "sends query" do
        subject
        expect(a_request(:get, %r{www.europeana.eu/api/v2/search.json?query=test})).
          to have_been_made.once
      end
    end
  end
end
