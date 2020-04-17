# (c) Copyright 2020 Ribose Inc.
#

module Jekyll
  module Geolexica
    module Configuration
      def concepts_glob
        glob_string = glossary_config["concepts_glob"]
        File.expand_path(glob_string, site.source)
      end

      def output_html?
        glossary_config["formats"].include?("html")
      end

      def output_json?
        glossary_config["formats"].include?("json")
      end

      def output_jsonld?
        glossary_config["formats"].include?("json-ld")
      end

      def output_turtle?
        glossary_config["formats"].include?("turtle")
      end

      protected

      def glossary_config
        site.config["geolexica"] || {}
      end
    end
  end
end
