# frozen_string_literal: true
RSpec.shared_examples 'a resource with API endpoint' do |endpoint, method|
  subject { described_class }

  it { is_expected.to respond_to(endpoint) }

  it "has #{endpoint} endpoint registered" do
    expect(subject.api_endpoints).to have_key(endpoint)
    expect(subject.api_endpoints[endpoint][:method]).to eq(method)
  end
end
