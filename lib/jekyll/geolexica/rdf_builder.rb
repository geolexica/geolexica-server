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

        each_language do |lang, l_data|
          l_data["terms"].each.with_index do |term, term_idx|
            label = term_idx.zero? ? SKOS.prefLabel : SKOS.altLabel
            add_statement(concept, label, term["designation"], language: lang)
          end
        end

        @graph
      end

      private

      # Graph subjects

      def concept
        @concept ||=
          RDF::URI.new("https://www.geolexica.org/concepts/#{termid}/#")
      end

      # Graph building

      def each_language
        Enumerator.new do |y|
          supported_langs = (term_languages & data.keys)
          supported_langs.each { |lang| y << [lang, data[lang]] }
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
      end
    end
  end
end
