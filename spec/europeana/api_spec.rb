# frozen_string_literal: true
describe Europeana::API do
  let(:api_key) { 'xyz' }
  let(:record_id) { '/abc/1234' }
  let(:params) { { callback: 'doSomething();' } }

  before(:each) do
    described_class.defaults!
  end

  describe '.url' do
    it 'defaults to the production API URL' do
      expect(subject.url).to eq('https://www.europeana.eu/api')
    end
  end

  describe '.url=' do
    let(:url) { 'http://www.example.com/api' }
    it 'accepts override of the API URL' do
      described_class.url = url
      expect(described_class.instance_variable_get(:@url)).to eq(url)
    end
  end

  describe '.api_key=' do
    it 'sets the API key' do
      described_class.api_key = api_key
      expect(described_class.instance_variable_get(:@api_key)).to eq(api_key)
    end
  end

  describe '.api_key' do
    it 'gets the API key' do
      described_class.instance_variable_set(:@api_key, api_key)
      expect(described_class.api_key).to eq(api_key)
    end
  end

  describe '.max_retries' do
    it 'defaults to 5' do
      expect(described_class.max_retries).to eq(5)
    end
  end

  describe '.max_retries=' do
    it 'sets the maximum number of retries' do
      described_class.max_retries = 2
      expect(described_class.max_retries).to eq(2)
    end
  end

  describe '.retry_delay' do
    it 'defaults to 10' do
      expect(described_class.retry_delay).to eq(3)
    end
  end

  describe '.retry_delay=' do
    it 'sets the retry delay' do
      described_class.retry_delay = 2
      expect(described_class.retry_delay).to eq(2)
    end
  end

  describe '.defaults!' do
    it 'sets the API URL to its default' do
      described_class.url = 'http://www.example.com/api'
      expect { described_class.defaults! }.
        to change { described_class.url }.
        from('http://www.example.com/api').
        to('https://www.europeana.eu/api')
    end

    it 'sets retry delay to its default' do
      described_class.retry_delay = 2
      expect { described_class.defaults! }.to change { described_class.retry_delay }.from(2).to(3)
    end

    it 'sets max retries to its default' do
      described_class.max_retries = 3
      expect { described_class.defaults! }.to change { described_class.max_retries }.from(3).to(5)
    end
  end

  describe '.record' do
    subject { described_class.record(record_id, params) }
    it_behaves_like 'record request'
  end
end
