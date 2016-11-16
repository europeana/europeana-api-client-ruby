# frozen_string_literal: true
RSpec.describe Europeana::API::Record do
  it_behaves_like 'a resource with API endpoint', :get
  it_behaves_like 'a resource with API endpoint', :search
  it_behaves_like 'a resource with API endpoint', :self
  it_behaves_like 'a resource with API endpoint', :parent
  it_behaves_like 'a resource with API endpoint', :children
  it_behaves_like 'a resource with API endpoint', :following_siblings
  it_behaves_like 'a resource with API endpoint', :preceding_siblings
  it_behaves_like 'a resource with API endpoint', :ancestor_self_siblings

  describe '.get' do
    before do
      stub_request(:get, %r{://www\.europeana\.eu/api/v2/record/abc/123\.json}).
        to_return(status: 200, body: '{"success":true, "object":{}}', headers: { 'Content-Type' => 'application/json' })
    end

    it 'requests a record from the API' do
      described_class.get(id: '/abc/123')
      expect(a_request(:get, %r{www\.europeana\.eu/api/v2/record/abc/123\.json})).to have_been_made.once
    end

    it 'returns the body of the response' do
      record = described_class.get(id: '/abc/123')
      expect(record).to be_an(OpenStruct)
      expect(record).to respond_to(:object)
    end
  end

  describe '.search' do
    before do
      stub_request(:get, %r{://www\.europeana\.eu/api/v2/search\.json}).
        to_return(status: 200, body: '{"success":true, "items":[]}', headers: { 'Content-Type' => 'application/json' })
    end

    it 'requests a record search from the API' do
      described_class.search(query: '*:*')
      expect(a_request(:get, %r{www\.europeana\.eu/api/v2/search\.json\?query=*:*})).to have_been_made.once
    end

    it 'returns the body of the response' do
      results = described_class.search(query: '*:*')
      expect(results).to be_an(OpenStruct)
      expect(results).to respond_to(:items)
    end
  end

  %w(self parent children preceding_siblings following_siblings ancestor_self_siblings).each do |endpoint|
    describe ".#{endpoint}" do
      before do
        stub_request(:get, %r{://www\.europeana\.eu/api/v2/record/abc/123/#{endpoint.to_s.dasherize}\.json}).
          to_return(status: 200, body: %Q({"success":true, "#{endpoint.to_s.dasherize}":[]}), headers: { 'Content-Type' => 'application/json' })
      end

      it "requests a record's #{endpoint.to_s.humanize.downcase} from the API" do
        described_class.send(endpoint, { id: '/abc/123' })
        expect(a_request(:get, %r{www\.europeana\.eu/api/v2/record/abc/123/#{endpoint.to_s.dasherize}\.json})).to have_been_made.once
      end

      it 'returns the body of the response' do
        results = described_class.send(endpoint, { id: '/abc/123' })
        expect(results).to be_an(OpenStruct)
        expect(results).to respond_to(endpoint)
      end
    end
  end

  describe '.escape' do
    it 'escapes Lucene characters'
  end
end
