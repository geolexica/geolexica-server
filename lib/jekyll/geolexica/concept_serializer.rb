module Jekyll
  module Geolexica
    # A decorator responsible for serializing concepts in the most simplistic
    # machine-readable formats like JSON or YAML but unlike RDF ontologies.
    class ConceptSerializer < SimpleDelegator
      include Configuration

      NON_LANGUAGE_KEYS = %w[term termid]

      # A Jekyll::Site instance.
      attr_reader :site

      def initialize(concept, site)
        super(concept)
        @site = site
      end
    end
  end
end
