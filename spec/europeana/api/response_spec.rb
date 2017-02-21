# frozen_string_literal: true
RSpec.describe Europeana::API::Response do
  it 'handles blank responses' do
    request = instance_double("Europeana::API::Request", endpoint: {})
    faraday_response = instance_double("Faraday::Response", status: 204, body: '')
    response = described_class.new(request, faraday_response)
    expect { response.validate! }.not_to raise_error
    expect(response.body).to eq('')
  end
end
