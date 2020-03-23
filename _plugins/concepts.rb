module Jekyll
  module Geolexica
    class ConceptsGenerator < Generator
      safe true

      attr_reader :generated_pages, :site

      # Generates Geolexica concept pages, both HTML and machine-readable.
      def generate(site)
        Jekyll.logger.info("Geolexica:", "Generating concept pages")

        # Jekyll does not say why it's a good idea, and whether such approach
        # is thread-safe or not, but most plugins in the wild do exactly that,
        # including these authored by Jekyll team.
        @site = site
        @generated_pages = []

        make_pages
        sort_pages
        group_pages_in_collections
      end

      # Processes concepts and yields a bunch of Jekyll::Page instances.
      def make_pages
        Dir.glob(concepts_glob).each do |concept_file_path|
          Jekyll.logger.debug("Geolexica:",
            "processing concept data #{concept_file_path}")
          concept_hash = YAML.load(File.read concept_file_path)
          add_page ConceptPage::HTML.new(site, concept_hash)
          add_page ConceptPage::JSON.new(site, concept_hash)
          add_page ConceptPage::JSONLD.new(site, concept_hash)
          add_page ConceptPage::Turtle.new(site, concept_hash)
        end
      end

      def sort_pages
        generated_pages.sort_by! { |p| p.termid.to_s }
      end

      def group_pages_in_collections
        generated_pages.each do |page|
          site.collections[page.collection_name].docs.push(page)
        end
      end

      def concepts_glob
        File.expand_path("../geolexica-database/concepts/*.yaml", __dir__)
      end

      def add_page *pages
        self.generated_pages.concat(pages)
      end

      def find_page(name)
        site.pages.detect { |page| page.name == name }
      end
    end

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
          nil
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
          "/api/concepts/:basename.json"
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
          "/api/concepts/:basename.jsonld"
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
          "/api/concepts/:basename.ttl"
        end
      end
    end
  end
end
