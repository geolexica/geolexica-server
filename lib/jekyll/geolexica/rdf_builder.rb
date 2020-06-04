# (c) Copyright 2020 Ribose Inc.
#

require "rdf"
require "rdf/vocab"

module Jekyll
  module Geolexica
    class RDFBuilder
      include Configuration
      extend Forwardable

      # Shortcut access to vocabularies (no need to prefix with RDF)
      DC = RDF::Vocab::DC
      OWL = RDF::OWL
      RDFS = RDF::RDFS
      SKOS = RDF::Vocab::SKOS
      XSD = RDF::XSD

      GX = RDF::Vocabulary.new("https://www.geolexica.org/api/rdf#")

      # This is concept data, which is different than site.data
      attr_reader :data

      # Supported languages defined for this concept
      attr_reader :languages

      # Jekyll::Site instance
      attr_reader :site
      attr_reader :glossary_concept

      def_delegator :glossary_concept, :data

      def_delegator :glossary_concept, :termid

      def initialize(concept, site)
        @glossary_concept = concept
        @site = site
        @languages = term_languages & data.keys
      end

      def build_graph
        @graph = RDF::Graph.new

        add_statement(concept, RDF.type, SKOS.Concept)
        # add_statement(concept, SKOS.prefLabel, "some label", language: "eng")
        add_statement(concept, SKOS.inScheme, GX.GeolexicaConceptScheme)

        # localized concept

          # binding.pry

        # for lang, l_data in each_language do
        #   binding.pry
        # end

        each_language do |lang, l_data|
          l_data["terms"].each.with_index do |term, term_idx|
            label = term_idx.zero? ? SKOS.prefLabel : SKOS.altLabel
            add_statement(concept, label, literal(term["designation"], lang))
          end rescue binding.pry


          # add_statement(concept, Profile["#{lang}Origin"], Profile[language_data(lang)["lang_en"]])
          # add_statement(concept, Profile["#{lang}Origin"], Profile[language_data(lang)["lang_en"]])
          # add_statement(concept, SKOS.definition, l_data.dig("definition"), language: lang)
          # add_statement(concept, SKOS.prefLabel, l_data.dig("term"), language: lang) # TODO escape filter
          # add_statement(concept, SKOS.altLabel, l_data.dig("alt"), language: lang) # TODO escape filter
        end

        @graph
      end

=begin
      def build_graph
        @graph = RDF::Graph.new

        add_statement(concept, RDF.type, OWL.Ontology)

        # concept itself

        # is trailing '#' okay?
        add_statement(concept, OWL.imports, DC.to_uri)
        add_statement(concept, OWL.imports, Profile.to_uri)
        add_statement(concept, OWL.imports, SKOS.to_uri)

        # concept:closure

        add_statement(concept_closure, RDF.type, SKOS.Concept)
        add_statement(concept_closure, DC.source, en_data.dig("authoritative_source", "link"))

        add_statement(concept_closure, Profile.termID, RDF::URI(page_url))

        add_statement(concept_closure, SKOS.inScheme, Profile.GeolexicaConceptScheme)
        add_statement(concept_closure, RDFS.label, en_data["term"]) # TODO escape filter
        add_statement(concept_closure, SKOS.notation, term_id)

        add_statement(concept_closure, DC.dateAccepted, en_data["date_accepted"]) # TODO format "%F"
        add_statement(concept_closure, DC.modified, en_data["date_amended"]) # TODO format "%F"
        add_statement(concept_closure, concept_status, en_data["entry_status"]) # TODO escape
        add_statement(concept_closure, concept_classification, en_data["classification"]) # TODO escape

        # concept:closure translatable part

        each_language do |lang, l_data|
          add_statement(concept_closure, Profile["#{lang}Origin"], Profile[language_data(lang)["lang_en"]])
          add_statement(concept_closure, SKOS.definition, l_data.dig("definition"), language: lang)
          add_statement(concept_closure, SKOS.prefLabel, l_data.dig("term"), language: lang) # TODO escape filter
          add_statement(concept_closure, SKOS.altLabel, l_data.dig("alt"), language: lang) # TODO escape filter
        end

        # concept:linked-data-api

        add_statement(concept_linked_data_api, RDF.type, DC.MediaTypeOrExtent)
        add_statement(concept_linked_data_api, SKOS.prefLabel, "linked-data-api")

        graph
      end
=end
      private

      # Graph subjects

      def concept
        @concept ||=
          RDF::URI.new("https://www.geolexica.org/concepts/#{termid}/#")
      end

      # Graph building

      def each_language
        term_languages.each do |lang|
          yield lang, data[lang] if data.key?(lang)
        end
      end

      def add_statement(subject, predicate, object, **options)
        return if object.nil?
        add_statement!(subject, predicate, object, **options)
      end

      def add_statement!(subject, predicate, object, language: nil)
        if language
          object = rdf_literal(object, language)
        end

        @graph << RDF::Statement.new(subject, predicate, object)
      end

      def rdf_literal(string, language = nil)
        short_code = language && language_to_bcp47(language)
        RDF::Literal.new(string, language: short_code)
      end

      # Utils

      def language_to_bcp47(long_code)
        language_data = site.data["lang"][long_code]
        language_data["iso-639-1"]
          short_code = language_data(language)["iso-639-1"]
          object = RDF::Literal.new(object, language: short_code)
        end

        s = RDF::Statement.new(subject, predicate, object)
        @graph << s
      end

      def language_data(long_code)
        site.data["lang"][long_code]
      end
    end
  end
end
