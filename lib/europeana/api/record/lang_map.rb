# frozen_string_literal: true

require 'iso-639'

module Europeana
  module API
    class Record
      ##
      # Methods for working with "LangMap" data types in Record API JSON responses
      #
      # @see https://pro.europeana.eu/resources/apis/search#json-langmap
      module LangMap
        # @see https://www.loc.gov/standards/iso639-2/php/code_changes.php
        DEPRECATED_ISO_LANG_CODES = %w(in iw jaw ji jw mo mol scc scr sh)

        # Special keys API may return in a LangMap, not ISO codes
        # TODO: Empty key acceptance is a workaround for malformed API data
        #   output; remove when fixed at source
        NON_ISO_LANG_CODES = ['def', '']

        class << self
          # Is the argument a language map?
          #
          # Critera:
          # * Must be a +Hash+.
          # * Must have only keys which are known language codes
          #
          # @param candidate [Object] Object to check
          # @return [Boolean]
          def lang_map?(candidate)
            return false unless candidate.is_a?(Hash)
            candidate.keys.map(&:to_s).all? { |key| known_lang_map_key?(key) }
          end

          # Is the argument a known language map key?
          #
          # @param key [String] String to check
          # @return [Boolean]
          def known_lang_map_key?(key)
            key = key.dup.downcase
            DEPRECATED_ISO_LANG_CODES.include?(key) ||
              NON_ISO_LANG_CODES.include?(key) ||
              !ISO_639.find(key.split('-').first).nil?
          end

          # Localise a language map
          #
          # 1. If the argument is not a language map, return as-is
          # 2. If the language map has a key for the current locale, return that
          #    value
          # 3. If the language map has a key for the default locale, return that
          #    value
          # 4. Else, return all values
          #
          # Arrays will be recursed over, localising each element.
          #
          # @param lang_map [Object] Object to attempt to localise
          # @return [Object,Array<Object>] Localised value
          def localise_lang_map(lang_map)
            if lang_map.is_a?(Array)
              return lang_map.map { |val| localise_lang_map(val) }
            end

            return lang_map unless lang_map?(lang_map)

            lang_map_value(lang_map, ::I18n.locale.to_s) ||
              lang_map_value(lang_map, ::I18n.default_locale.to_s) ||
              lang_map_value(lang_map, 'def') ||
              lang_map.values
          end

          # Fetch the language map value for a given locale
          #
          # @param lang_map [Hash] Verified language map
          # @param locale [String] Locale to fetch the value for
          # @return [Array<Object>,nil] Array of value(s) for the given locale,
          #   or nil if none are present
          def lang_map_value(lang_map, locale)
            keys = salient_lang_map_keys(lang_map, locale)
            return nil unless keys.present?
            keys.map { |k| lang_map[k] }.flatten.uniq
          end

          protected

          # @return [Array<String>] valid keys in the language map for the given locale
          def salient_lang_map_keys(lang_map, locale)
            iso_code = locale.split('-').first
            iso_locale = ISO_639.find(iso_code)

            # Favour exact matches
            keys = lang_map.keys.select do |k|
              [locale, iso_locale&.alpha2, iso_locale&.alpha3].include?(k)
            end.flatten.compact
            return keys unless keys.blank?

            # Any sub-code will do
            lang_map.keys.select do |k|
              k =~ %r{\A#{iso_code}-}
            end.flatten.compact
          end
        end
      end
    end
  end
end
