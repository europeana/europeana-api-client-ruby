module Europeana
  class Search
    ##
    # API field information and validation in search context
    #
    # @see http://labs.europeana.eu/api/data-fields/
    module Fields
      EDM_PROVIDED_CHO = %w(edm_europeana_proxy proxy_dc_contributor
        proxy_dc_coverage proxy_dc_creator proxy_dc_date proxy_dc_description
        proxy_dc_format proxy_dc_identifier proxy_dc_language
        proxy_dc_publisher proxy_dc_relation proxy_dc_rights proxy_dc_source
        proxy_dc_subject proxy_dc_title proxy_dc_type
        proxy_dcterms_alternative proxy_dcterms_conformsTo
        proxy_dcterms_created proxy_dcterms_extent proxy_dcterms_hasFormat
        proxy_dcterms_hasPart proxy_dcterms_hasVersion
        proxy_dcterms_isFormatOf proxy_dcterms_isPartOf
        proxy_dcterms_isReferencedBy proxy_dcterms_isReplacedBy
        proxy_dcterms_isRequiredBy proxy_dcterms_issued
        proxy_dcterms_isVersionOf proxy_dcterms_medium
        proxy_dcterms_provenance proxy_dcterms_references
        proxy_dcterms_replaces proxy_dcterms_requires proxy_dcterms_spatial
        proxy_dcterms_tableOfContents proxy_dcterms_temporal
        proxy_edm_currentLocation proxy_edm_currentLocation_lat
        proxy_edm_currentLocation_lon proxy_edm_hasMet proxy_edm_hasType
        proxy_edm_incorporates proxy_edm_isDerivativeOf
        proxy_edm_isNextInSequence proxy_edm_isRelatedTo
        proxy_edm_isRepresentationOf proxy_edm_isSimilarTo
        proxy_edm_isSuccessorOf proxy_edm_realizes proxy_edm_type
        proxy_edm_unstored proxy_edm_wasPresentAt proxy_owl_sameAs
        proxy_edm_rights proxy_edm_userTags proxy_edm_year proxy_ore_proxy
        proxy_ore_proxyFor proxy_ore_proxyIn)

      ORE_AGGREGATION = %w(provider_aggregation_ore_aggregation
        provider_aggregation_ore_aggregates
        provider_aggregation_edm_aggregatedCHO
        provider_aggregation_edm_dataProvider
        provider_aggregation_edm_hasView provider_aggregation_edm_isShownAt
        provider_aggregation_edm_isShownBy provider_aggregation_edm_object
        provider_aggregation_edm_provider provider_aggregation_dc_rights
        provider_aggregation_edm_rights edm_UGC
        provider_aggregation_edm_unstored edm_previewNoDistribute)

      EDM_EUROPEANA_AGGREGATION = %w(edm_europeana_aggregation
        europeana_aggregation_dc_creator europeana_aggregation_edm_country
        europeana_aggregation_edm_hasView europeana_aggregation_edm_isShownBy
        europeana_aggregation_edm_landingPage
        europeana_aggregation_edm_language europeana_aggregation_edm_rights
        europeana_aggregation_ore_aggregatedCHO
        europeana_aggregation_ore_aggregates)

      EDM_WEB_RESOURCE = %w(edm_webResource wr_dc_description wr_dc_format
        wr_dc_rights wr_dc_source wr_dcterms_conformsTo wr_dcterms_created
        wr_dcterms_extent wr_dcterms_hasPart wr_dcterms_isFormatOf
        wr_dcterms_issued wr_edm_isNextInSequence wr_edm_rights)

      EDM_AGENT = %w(edm_agent ag_skos_prefLabel ag_skos_altLabel
        ag_skos_hiddenLabel ag_skos_note ag_dc_date ag_dc_identifier
        ag_edm_begin ag_edm_end ag_edm_hasMet ag_edm_isRelatedTo
        ag_edm_wasPresentAt ag_foaf_name ag_rdagr2_biographicalInformation
        ag_rdagr2_dateOfBirth ag_rdagr2_dateOfDeath
        ag_rdagr2_dateOfEstablishment ag_rdagr2_dateOfTermination
        ag_rdagr2_gender ag_rdagr2_professionOrOccupation ag_owl_sameAs)

      SKOS_CONCEPT = %w(skos_concept cc_skos_prefLabel cc_skos_altLabel
        cc_skos_hiddenLabel cc_skos_broader cc_skos_broaderLabel
        cc_skos_narrower cc_skos_related cc_skos_broadMatch
        cc_skos_narrowMatch cc_skos_relatedMatch cc_skos_exactMatch
        cc_skos_closeMatch cc_skos_note cc_skos_notation cc_skos_inScheme)

      EDM_PLACE = %w(edm_place pl_wgs84_pos_lat pl_wgs84_pos_long
        pl_wgs84_pos_alt pl_wgs84_pos_lat_long pl_skos_prefLabel
        pl_skos_altLabel pl_skos_hiddenLabel pl_skos_note pl_dcterms_hasPart
        pl_dcterms_isPartOf pl_owl_sameAs pl_dcterms_isPartOf_label)

      EDM_TIME_SPAN = %w(edm_timespan ts_skos_prefLabel ts_skos_altLabel
        ts_skos_hiddenLabel ts_skos_note ts_dcterms_hasPart
        ts_dcterms_isPartOf ts_edm_begin ts_edm_end ts_owl_sameAs
        ts_dcterms_isPartOf_label)

      NON_EDM = %w(europeana_completeness europeana_previewNoDistribute
        timestamp europeana_id identifier europeana_collectionName)

      AGGREGATED = %w(country date description format language location
        publisher relation rights source subject text title what when where
        who)

      FACETS = %w(COMPLETENESS CONTRIBUTOR COUNTRY DATA_PROVIDER LANGUAGE
        LOCATION PROVIDER RIGHTS SUBJECT TYPE UGC USERTAGS YEAR)

      AGGREGATED_FACETS = %w(DEFAULT)

      MEDIA = %w(COLOURPALETTE IMAGE_ASPECTRATIO IMAGE_COLOR IMAGE_COLOUR
                 IMAGE_GRAYSCALE IMAGE_GREYSCALE IMAGE_SIZE MEDIA MIME_TYPE
                 SOUND_DURATION SOUND_HQ TEXT_FULLTEXT VIDEO_DURATION VIDEO_HD)

      ##
      # Tests whether the given field name is valid in the API search context
      #
      # @param name [String] field name
      # @return [Boolean]
      def self.include?(name)
        constants.any? do |scope|
          const_get(scope).any? do |field|
            field == name
          end
        end
      end
    end
  end
end
