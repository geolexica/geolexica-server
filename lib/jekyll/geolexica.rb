# (c) Copyright 2020 Ribose Inc.
#

require "jekyll"

module Jekyll
  module Geolexica
  end
end

require_relative "geolexica/concept_page"
require_relative "geolexica/concepts_generator"
require_relative "geolexica/meta_pages_generator"
