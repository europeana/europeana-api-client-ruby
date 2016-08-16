RSpec.describe Europeana::API::Client do
  describe '.request' do
    context 'without URL' do
      it 'fails' do
        expect { described_class.request }.to raise_error(ArgumentError)
      end
    end

    context 'with URL' do
      context 'without method' do
        it 'sends an HTTP GET request to it' do
          url = 'http://www.example.com/'
          stub_request(:get, url)
          described_class.request(url: url)
          expect(a_request(:get, url)).to have_been_made.once
        end
      end

      context 'with method' do
        it 'sends that HTTP verb request to it' do
          url = 'http://www.example.com/'
          stub_request(:put, url)
          described_class.request(url: url, method: :put)
          expect(a_request(:put, url)).to have_been_made.once
        end
      end

      context 'when request fails' do
        it 'retries up to 5 times' do
          url = 'http://www.example.com/'
          stub_request(:get, url).
            to_timeout.times(3).then.
            to_return({body: 'OK'})

          described_class.request(url: url)
          expect(a_request(:get, url)).to have_been_made.times(4)
        end
      end
    end
  end
end
