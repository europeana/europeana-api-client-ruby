# frozen_string_literal: true

RSpec.describe Europeana::API::Record::LangMap do
  describe '.lang_map?' do
    subject { described_class.lang_map?(var) }

    context 'when not a Hash' do
      let(:var) { [] }
      it { is_expected.to be false }
    end

    context 'when a Hash' do
      context 'with non-language code keys' do
        let(:var) { { 'first' => 'this', 'then' => 'that' } }
        it { is_expected.to be false }
      end

      context 'with language code keys' do
        let(:var) { { 'en' => 'this', 'fr' => 'ce' } }
        it { is_expected.to be true }
      end
    end
  end
end
