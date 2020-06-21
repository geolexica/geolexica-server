# (c) Copyright 2020 Ribose Inc.
#

require "jekyll"

module Jekyll
  module Geolexica
  end
end

require_relative "geolexica/configuration"
require_relative "geolexica/concept_page"
require_relative "geolexica/concept_serializer"
require_relative "geolexica/concepts_generator"
require_relative "geolexica/glossarize_filter"
require_relative "geolexica/glossary"
require_relative "geolexica/hooks"
require_relative "geolexica/meta_pages_generator"

Jekyll::Geolexica::Hooks.register_all_hooks
