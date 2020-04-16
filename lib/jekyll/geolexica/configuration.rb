# (c) Copyright 2020 Ribose Inc.
#

module Jekyll
  module Geolexica
    module Configuration
      def concepts_glob
        glob_string = glossary_config["concepts_glob"]
        File.expand_path(glob_string, site.source)
      end

      protected

      def glossary_config
        site.config["geolexica"] || {}
      end
    end
  end
end
