RSpec.describe Europeana::API::Record do
  let(:api_key) { 'xyz' }
  let(:record_id) { '/abc/1234' }
  let(:params) { { callback: 'doSomething();' } }

  before do
    Europeana::API.api_key = api_key
  end

  describe '#new' do
    context 'without record ID' do
      it 'raises error' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context 'with record ID' do
      context 'without params' do
        subject { described_class.new(record_id) }

        it 'should not raise error' do
          expect { subject }.to_not raise_error
        end

        it 'sets id attribute' do
          expect(subject.instance_variable_get(:@id)).to eq(record_id)
        end
      end

      context 'with params' do
        subject { described_class.new(record_id, params) }

        it 'should not raise error' do
          expect { subject }.to_not raise_error
        end

        it 'sets params attribute' do
          expect(subject.instance_variable_get(:@params)).to eq(params)
        end
      end
    end
  end

  describe '#id' do
    subject { described_class.new(record_id) }
    it 'gets id attribute' do
      expect(subject.id).to eq(subject.instance_variable_get(:@id))
    end
  end

  describe '#id=' do
    subject { described_class.new(record_id) }

    context 'with valid ID' do
      it 'sets id attribute' do
        subject.id = '/xyz/5678'
        expect(subject.instance_variable_get(:@id)).to eq('/xyz/5678')
      end
    end

    context 'invalid ID' do
      it 'raises error' do
        expect { subject.id = 'invalid' }.to raise_error('Invalid Europeana record ID: "invalid"')
      end
    end
  end

  describe '#params' do
    subject { described_class.new(record_id, params) }
    it 'gets params attribute' do
      expect(subject.params).to eq(subject.instance_variable_get(:@params))
    end
  end

  describe '#params=' do
    subject { described_class.new(record_id, {}) }

    context 'valid params' do
      it 'sets params attribute' do
        subject.params = params
        expect(subject.instance_variable_get(:@params)).to eq(params)
      end
    end

    it 'validates param names' do
      expect { subject.params = { :invalid => 'parameter' } }.to raise_error(/Unknown key: :?invalid/)
    end
  end

  describe '#params_with_authentication' do
    subject { described_class.new(record_id, params) }

    context 'with API key' do
      it 'adds API key to params' do
        expect(subject.params_with_authentication).to eq(params.merge(:wskey => api_key))
      end
    end

    context 'without API key' do
      it 'raises an error' do
        Europeana::API.api_key = nil
        expect { subject.params_with_authentication }.to raise_error(Europeana::API::Errors::MissingAPIKeyError)
      end
    end
  end

  describe '#request_uri' do
    subject { described_class.new(record_id, params) }

    it 'returns a URI' do
      expect(subject.request_uri).to be_a(URI)
    end

    it 'includes the record ID' do
      expect(subject.request_uri.to_s).to include(record_id)
    end

    it 'includes the query params' do
      expect(subject.request_uri.to_s).to include(params.to_query)
    end
  end

  describe '#get' do
    subject { described_class.new(record_id, params).get }
    it_behaves_like 'record request'
  end

  describe '#hierarchy' do
    let(:record) { described_class.new(record_id, params) }
    subject { record.hierarchy }
    it { is_expected.to be_a(Europeana::API::Record::Hierarchy) }
    it 'should have assigned record attr' do
      expect(subject.record).to eq(record)
    end
    it 'should fetch record hierarchy' do
      subject
      expect(a_request(:get, %r{www.europeana.eu/api/v2/record#{record_id}/self.json})).to have_been_made.once
    end
  end
end
