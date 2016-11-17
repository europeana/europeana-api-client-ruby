# frozen_string_literal: true
describe Europeana::API do
  let(:api_key) { 'xyz' }

  describe '.url' do
    it 'defaults to the production API URL' do
      expect(described_class.url).to eq('https://www.europeana.eu/api')
    end
  end

  describe '.url=' do
    let(:url) { 'http://www.example.com/api' }
    it 'accepts override of the API URL' do
      described_class.url = url
      expect(described_class.instance_variable_get(:@url)).to eq(url)
    end
  end

  describe '.key=' do
    it 'sets the API key' do
      described_class.key = api_key
      expect(described_class.instance_variable_get(:@key)).to eq(api_key)
    end
  end

  describe '.key' do
    it 'gets the API key' do
      described_class.instance_variable_set(:@key, api_key)
      expect(described_class.key).to eq(api_key)
    end
  end

  describe '.record' do
    subject { described_class.record }
    it { is_expected.to eq(Europeana::API::Record) }
  end

  describe '.annotation' do
    subject { described_class.annotation }
    it { is_expected.to eq(Europeana::API::Annotation) }
  end
end
