# (c) Copyright 2020 Ribose Inc.
#

module Jekyll
  module Geolexica
    class ConceptPage < PageWithoutAFile
      attr_reader :concept_hash

      def initialize(site, concept_hash)
        @concept_hash = concept_hash
        @data = default_data.merge(concept_hash)

        super(site, site.source, "concepts", page_name)
      end

      def termid
        concept_hash["termid"]
      end

      def type
        self.collection_name.to_sym
      end

      protected

      def default_data
        {"layout" => layout, "permalink" => permalink}
      end

      class HTML < ConceptPage
        def page_name
          "#{termid}.html"
        end

        def collection_name
          "concepts"
        end

        def layout
          "concept"
        end

        def permalink
          "/concepts/#{termid}/"
        end
      end

      class JSON < ConceptPage
        def page_name
          "#{termid}.json"
        end

        def collection_name
          "concepts_json"
        end

        def layout
          "concept.json"
        end

        def permalink
          "/api/concepts/#{termid}.json"
        end
      end

      class JSONLD < ConceptPage
        def page_name
          "#{termid}.jsonld"
        end

        def collection_name
          "concepts_jsonld"
        end

        def layout
          "concept.jsonld"
        end

        def permalink
          "/api/concepts/#{termid}.jsonld"
        end
      end

      class Turtle < ConceptPage
        def page_name
          "#{termid}.ttl"
        end

        def collection_name
          "concepts_ttl"
        end

        def layout
          "concept.ttl"
        end

        def permalink
          "/api/concepts/#{termid}.ttl"
        end
      end
    end
  end
end
