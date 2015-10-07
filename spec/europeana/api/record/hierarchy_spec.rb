RSpec.describe Europeana::API::Record::Hierarchy do
  let(:record_id) { '/abc/1234' }
  let(:params) { { callback: 'doSomething();' } }

  context 'when initialized with record ID' do
    subject { described_class.new(record_id) }

    it { is_expected.to be_a(HashWithIndifferentAccess) }
    it { is_expected.to respond_to(:execute_request) }

    it 'should retrieve self hierarchy data from the API' do
      subject
      expect(a_request(:get, %r{www.europeana.eu/api/v2/record#{record_id}/self.json})).to have_been_made.once
    end

    describe '#request_url' do
      it 'should default relation to self' do
        expect(subject.request_url).to match(%r{/record#{record_id}/self.json})
      end
    end

    describe '#[]' do
      it 'should be the content of the API self response' do
        expect(subject).not_to have_key(:self)
        expect(subject).to have_key(:id)
      end
    end
  end
end
