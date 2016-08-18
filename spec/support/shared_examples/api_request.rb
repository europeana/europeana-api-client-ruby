# frozen_string_literal: true
shared_examples 'API request' do
  context 'without API key' do
    before(:each) do
      Europeana::API.api_key = nil
    end

    it 'sends no HTTP request' do
      begin
        subject
      rescue Europeana::API::Errors::MissingAPIKeyError
      end
      expect(a_request(:get, %r{www.europeana.eu/api})).not_to have_been_made
    end
  end

  context 'with API key' do
    before(:all) do
      Europeana::API.api_key = 'xyz'
    end

    it 'returns the response as a Hash' do
      response = subject
      expect(response).to be_a(Hash)
    end

    context 'when the API is unavailable' do
      before(:each) do
        Europeana::API.retry_delay = 0
      end

      it 'waits then retries' do
        stub_request(:get, %r{www.europeana.eu/api}).
          to_timeout.times(1).then.
          to_return(body: '{"success":true}')
        subject
        expect(a_request(:get, %r{www.europeana.eu/api})).to have_been_made.times(2)
      end
    end

    context 'when API response is unsuccessful' do
      context 'with error msg' do
        it 'raises a RequestError with error msg' do
          stub_request(:get, %r{www.europeana.eu/api}).to_return(body: '{"success":false,"error":"Something went wrong"}')
          expect { subject }.to raise_error(Europeana::API::Errors::RequestError, 'Something went wrong')
        end
      end

      context 'without error msg' do
        it 'raises a RequestError with status code' do
          stub_request(:get, %r{www.europeana.eu/api}).to_return(status: 400, body: '{"success":false}')
          expect { subject }.to raise_error(Europeana::API::Errors::RequestError, '400')
        end
      end
    end

    context 'when API response is invalid JSON' do
      it 'raises a ResponseError' do
        stub_request(:get, %r{www.europeana.eu/api}).to_return(body: 'invalid JSON')
        expect { subject }.to raise_error(Europeana::API::Errors::ResponseError)
      end
    end
  end
end
