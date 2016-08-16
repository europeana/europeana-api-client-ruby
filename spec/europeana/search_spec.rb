require 'active_support/core_ext/hash'

describe Europeana::Search do
  let(:api_key) { 'xyz' }
  let(:params) {
    HashWithIndifferentAccess.new({
      query: 'test', profile: 'standard', qf: "where:London", rows: 100, start: 1, callback: ''
    })
  }

  before do
    Europeana::API.api_key = api_key
  end

  describe "#new" do
    context "with no API request params" do
      subject { lambda { described_class.new } }
      it { should_not raise_error }
    end

    context "with API request params" do
      subject { described_class.new(params) }
      it "should not raise error" do
        expect { subject }.not_to raise_error
      end
      it "stores the request params" do
        expect(subject.instance_variable_get(:@params)).to eq(params)
      end
    end
  end

  describe "#params" do
    subject { described_class.new(params) }
    it "gets params attribute" do
      expect(subject.params).to eq(params)
    end
  end

  describe "#params=" do
    subject { described_class.new }

    context "valid params" do
      it "sets params attribute" do
        subject.params = params
        expect(subject.instance_variable_get(:@params)).to eq(params)
      end
    end
  end

  describe "#request_uri" do
    it "returns a URI" do
      expect(subject.request_uri).to be_a(URI)
    end

    it "includes request params" do
      subject.params[:query] = 'paris'
      expect(subject.request_uri.to_s).to eq("https://www.europeana.eu/api/v2/search.json?query=paris&wskey=#{api_key}")
    end
  end

  describe "#params_with_authentication" do
    subject { described_class.new }

    context "with API key" do
      it "adds API key to params" do
        subject.params = params
        expect(subject.params_with_authentication).to eq(params.merge(wskey: api_key))
      end
    end

    context "without API key" do
      it "raises an error" do
        subject.params = params
        Europeana::API.api_key = nil
        expect { subject.params_with_authentication }.to raise_error(Europeana::API::Errors::MissingAPIKeyError)
      end
    end
  end

  describe "#execute" do
    subject { described_class.new(params).execute }
    it_behaves_like "search request"
  end

  describe '.escape' do
    %w<\\ + - & | ! ( ) { } [ ] ^ " ~ * ? : />.map do |char|
      it "escapes lucene special character #{char}" do
        expect(described_class.escape(char)).to eq("\\#{char}")
      end
    end
  end
end
