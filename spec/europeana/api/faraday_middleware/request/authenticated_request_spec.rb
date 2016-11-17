# frozen_string_literal: true
RSpec.describe Europeana::API::FaradayMiddleware::AuthenticatedRequest do
  context 'with `Europeana::API.api_key` set' do
    context 'without `wskey` param' do
      it 'uses `Europeana::API.api_key`'
    end

    context 'with `wskey` param' do
      it 'uses `wskey` param'
    end
  end

  context 'without `Europeana::API.api_key` set' do
    context 'without `wskey` param' do
      it 'fails'
    end

    context 'with `wskey` param' do
      it 'uses `wskey` param'
    end
  end
end
