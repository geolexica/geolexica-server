# frozen_string_literal: true

# (c) Copyright 2020 Ribose Inc.
#

module Jekyll
  module Geolexica
    class BibliographyGenerator < Generator
      include Configuration

      safe true

      attr_reader :generated_pages, :site

      def generate(site)
        Jekyll.logger.info("Geolexica:", "Generating concept Bibliography")

        # Jekyll does not say why it's a good idea, and whether such approach
        # is thread-safe or not, but most plugins in the wild do exactly that,
        # including these authored by Jekyll team.
        @site = site
        @db = Relaton::Db.new(nil, nil)

        @site.data["bibliography"] ||= {}
        make_bibliography if File.exist?(bibliography_path)
      end

      def make_bibliography
        YAML.load_file(bibliography_path).each do |name, identifier|
          bib = @db.fetch(identifier["reference"])

          if bib.nil?
            bib = {
              "user_defined" => true,
              "reference" => identifier["reference"],
              "link" => identifier["link"]
            }.compact
          end

          @site.data["bibliography"][name] = bib.to_hash
        end
      end
    end
  end
end
