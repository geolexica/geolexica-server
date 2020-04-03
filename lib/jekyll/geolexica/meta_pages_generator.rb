# (c) Copyright 2020 Ribose Inc.
#

module Jekyll
  module Geolexica
    class MetaPagesGenerator < Generator
      safe true

      attr_reader :generated_pages, :site

      # Generates Geolexica meta pages, both HTML and machine-readable.
      def generate(site)
        Jekyll.logger.info("Geolexica:", "Generating meta pages")

        # Jekyll does not say why it's a good idea, and whether such approach
        # is thread-safe or not, but most plugins in the wild do exactly that,
        # including these authored by Jekyll team.
        @site = site
        @generated_pages = []

        make_pages
        site.pages.concat(generated_pages)
      end

      # Processes concepts and yields a bunch of Jekyll::Page instances.
      def make_pages
        Dir.glob("**/*", base: base_dir).each do |meta_page_path|
          pathname = Pathname.new(meta_page_path)
          next if pathname.expand_path(base_dir).directory?
          add_page Page.new(site, base_dir,
            pathname.dirname.to_s, pathname.basename.to_s)
        end
      end

      def base_dir
        File.expand_path("../../../_pages", __dir__)
      end

      def add_page *pages
        self.generated_pages.concat(pages)
      end
    end
  end
end
