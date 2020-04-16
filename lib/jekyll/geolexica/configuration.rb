# (c) Copyright 2020 Ribose Inc.
#

module Jekyll
  module Geolexica
    module Configuration
      protected

      def glossary_config
        site.config["geolexica"] || {}
      end
    end
  end
end
