# (c) Copyright 2020 Ribose Inc.
#

module Jekyll
  module Geolexica
    class ConceptsGenerator < Generator
      include Configuration

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
        site.glossary.each_concept do |concept|
          Jekyll.logger.debug("Geolexica:",
            "building pages for concept #{concept.termid}")
          add_page ConceptPage::HTML.new(site, concept) if output_html?
          add_page ConceptPage::JSON.new(site, concept) if output_json?
          add_page ConceptPage::JSONLD.new(site, concept) if output_jsonld?
          add_page ConceptPage::TBX.new(site, concept) if output_tbx?
          add_page ConceptPage::Turtle.new(site, concept) if output_turtle?
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

      def add_page *pages
        self.generated_pages.concat(pages)
      end

      def find_page(name)
        site.pages.detect { |page| page.name == name }
      end
    end
  end
end
