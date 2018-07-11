# frozen_string_literal: true

RSpec.describe Europeana::API::Record::LangMap do
  before do
    I18n.config.available_locales = %i(de en fr nl)
  end
  let(:lang_map_hash) do
    { 'def' => 'this', 'en' => 'this', 'fr' => 'ce' }
  end
  let(:non_lang_map_hash) do
    { 'first' => 'this', 'then' => 'that' }
  end

  describe '.lang_map?' do
    subject { described_class.lang_map?(var) }

    context 'when not a Hash' do
      let(:var) { [] }
      it { is_expected.to be false }
    end

    context 'when a Hash' do
      context 'with non-language code keys' do
        let(:var) { non_lang_map_hash }
        it { is_expected.to be false }
      end

      context 'with language code keys' do
        let(:var) { lang_map_hash }
        it { is_expected.to be true }
      end
    end
  end

  describe '.localise_lang_map' do
    subject { described_class.localise_lang_map(var) }

    context 'when an Array' do
      let(:var) { [lang_map_hash, lang_map_hash] }
      before do
        I18n.locale = :fr
      end

      it 'localises each element' do
        expect(subject).to eq([[lang_map_hash['fr']], [lang_map_hash['fr']]])
      end
    end

    context 'when not an Array' do
      context 'when a language map' do
        let(:var) { lang_map_hash }
        context 'when current locale is present' do
          before do
            I18n.locale = :fr
          end

          it 'is returned in array' do
            expect(subject).to eq([var['fr']])
          end
        end

        context 'when current locale is not present' do
          before do
            I18n.locale = :de
          end

          context 'when default locale is present' do
            before do
              I18n.default_locale = :en
            end

            it 'is returned in array' do
              expect(subject).to eq([var['en']])
            end
          end

          context 'when default locale is not present' do
            before do
              I18n.default_locale = :nl
            end

            context 'when "def" is present' do
              it 'is returned in array' do
                expect(subject).to eq([var['def']])
              end
            end

            context 'when "def" is not present' do
              before do
                lang_map_hash.delete('def')
              end
              it 'returns all values' do
                expect(subject).to eq(var.values)
              end
            end
          end
        end
      end

      context 'when not a language map' do
        let(:var) { non_lang_map_hash }
        it 'returns the argument' do
          expect(subject).to eq(var)
        end
      end
    end
  end
end
