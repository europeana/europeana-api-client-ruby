RSpec.describe Europeana::Record::Hierarchy do
  let(:record_id) { '/abc/1234' }
  let(:params) { { callback: 'doSomething();' } }

  subject { described_class.new(record_id) }

  %w(self parent children).each do |relation|
    describe "##{relation}" do
      it "should retrieve #{relation} hierarchy data from the API" do
        subject.send(relation)
        expect(a_request(:get, %r{www.europeana.eu/api/v2/record#{record_id}/#{relation}.json})).to have_been_made.once
      end
    end
  end
end
