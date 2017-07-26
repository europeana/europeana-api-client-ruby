# frozen_string_literal: true
RSpec.describe Europeana::API::Client do
  it { should delegate_method(:get).to(:connection) }
  it { should delegate_method(:post).to(:connection) }

  describe '.get' do
    context 'without URL' do
      it 'makes a request to the root API URL' do
        stub_request(:get, Regexp.new(Europeana::API.url))
        subject.get
        expect(a_request(:get, Regexp.new(Europeana::API.url))).to have_been_made.once
      end
    end

    context 'with URL' do
      context 'with GET method' do
        it 'sends an HTTP GET request to it' do
          url = 'http://www.example.com/'
          stub_request(:get, Regexp.new(url))
          subject.get(url)
          expect(a_request(:get, Regexp.new(url))).to have_been_made.once
        end
      end

      context 'when request fails' do
        it 'retries up to 5 times' do
          url = 'http://www.example.com/'
          stub_request(:get, Regexp.new(url)).to_raise(Errno::ECONNREFUSED).times(3).to_return(body: 'OK')

          subject.get(url)
          expect(a_request(:get, Regexp.new(url))).to have_been_made.times(4)
        end
      end

      context 'when request times out' do
        it 'does NOT retry' do
          url = 'http://www.example.com/'
          stub_request(:get, Regexp.new(url)).to_timeout.times(3).to_return(body: 'OK')

          expect { subject.get(url) }.to raise_error(Faraday::TimeoutError)
          expect(a_request(:get, Regexp.new(url))).to have_been_made.times(1)
        end
      end
    end
  end
end
