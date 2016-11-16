RSpec.describe Europeana::Annotation do
  before(:each) do
    described_class.reset!
  end

  it { is_expected.to be_a(Europeana::Resource) }

  describe '.path_prefix' do
    it 'defaults to "/annotations"' do
      expect(described_class.path_prefix).to eq('/annotations')
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

      it "returns instance of #{described_class}" do
        params = { provider: 'abc', id: '123' }
        api_url = %r{www.europeana.eu/api/annotations/#{params[:provider]}/#{params[:id]}}
        stub_request(:get, api_url).to_return(body: '{"success":true}')

        expect(described_class.fetch(params)).to be_a(described_class)
      end
    end
  end

  describe '.resource_url' do
    context 'with provider and id' do
      context 'with default URL prefix' do
        it 'combines them' do
          params = { provider: 'abc', id: '123' }
          expect(described_class.resource_url(params)).to eq('annotations/abc/123.jsonld')
        end
      end

      context 'with custom base URL' do
        it 'combines them' do
          described_class.base_url = 'http://www.example.com/api'
          params = { provider: 'abc', id: '123' }
          expect(described_class.resource_url(params)).to eq('http://www.example.com/api/annotations/abc/123.jsonld')
        end
      end

      context 'with custom path prefix' do
        it 'combines them' do
          described_class.path_prefix = '/annotation'
          params = { provider: 'abc', id: '123' }
          expect(described_class.resource_url(params)).to eq('annotation/abc/123.jsonld')
        end
      end
    end
  end
end
