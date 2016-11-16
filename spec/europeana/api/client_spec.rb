# frozen_string_literal: true
RSpec.describe Europeana::API::Client do
  describe '.get' do
    context 'without URL' do
      it 'fails' do
        expect { subject.get }.to raise_error(ArgumentError)
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
          stub_request(:get, Regexp.new(url)).to_timeout.times(3).to_return(body: 'OK')

          subject.get(url)
          expect(a_request(:get, Regexp.new(url))).to have_been_made.times(4)
        end
      end
    end
  end
end
