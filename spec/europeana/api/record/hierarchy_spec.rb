RSpec.describe Europeana::API::Record::Hierarchy do
  let(:record) { instance_double("Europeana::API::Record", id: record_id) }

  let(:record_id) { '/abc/1234' }
  let(:params) { { callback: 'doSomething();' } }

  subject { described_class.new(record) }

  it { is_expected.to be_a(Tree::TreeNode) }
  it { is_expected.to include(Europeana::API::Requestable) }

  it 'should retrieve self hierarchy data from the API' do
    subject
    expect(a_request(:get, %r{www.europeana.eu/api/v2/record#{record_id}/self.json})).to have_been_made.once
  end

  describe '#request_url' do
    it 'should default relation to self' do
      expect(subject.request_url).to match(%r{/record#{record_id}/self.json})
    end
  end

  describe '#content' do
    it 'should be the content of the API self response' do
      expect(subject.content).not_to have_key(:self)
      expect(subject.content).to have_key(:id)
    end
  end
end
