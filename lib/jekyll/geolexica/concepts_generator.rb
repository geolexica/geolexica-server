# (c) Copyright 2020 Ribose Inc.
#

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
          concept_hash = read_concept_file(concept_file_path)
          preprocess_concept_hash(concept_hash)
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
        glob_string = site.config.dig("geolexica", "concepts_glob")
        File.expand_path(glob_string, site.source)
      end

      def add_page *pages
        self.generated_pages.concat(pages)
      end

      def find_page(name)
        site.pages.detect { |page| page.name == name }
      end

      # Reads and parses concept file located at given path.
      def read_concept_file(path)
        YAML.load(File.read path)
      end

      # Does nothing, but some sites may replace this method.
      def preprocess_concept_hash(concept_hash)
      end
    end
  end
end
