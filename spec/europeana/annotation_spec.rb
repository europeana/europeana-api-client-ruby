RSpec.describe Europeana::Annotation do
  it { is_expected.to be_a(Europeana::Resource) }
  
  describe '.base_url' do
    it 'defaults to "https://www.europeana.eu/api/annotations"' do
      expect(described_class.base_url).to eq('https://www.europeana.eu/api/annotations')
    end
  end

  describe '.fetch' do
    context 'with provider and identifier' do
      it 'gets annotation from API' do
        params = { provider: 'abc', id: '123' }
        api_url = %r{www.europeana.eu/api/annotations/#{params[:provider]}/#{params[:id]}}
        stub_request(:get, api_url).to_return(body: '{"success":true}')

        described_class.fetch(params)
        expect(a_request(:get, api_url)).to have_been_made.once
      end
    end
  end

  describe '.resource_url' do
    context 'with provider and id' do
      it 'adds them to base URL' do
        params = { provider: 'abc', id: '123' }
        expect(described_class.resource_url(params)).to eq('https://www.europeana.eu/api/annotations/abc/123.jsonld')
      end
    end
  end
end
