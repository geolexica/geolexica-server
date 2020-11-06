# (c) Copyright 2020 Ribose Inc.
#

require "jekyll"

module Jekyll
  module Geolexica
    def self.load_tasks
      tasks_path = File.expand_path("../tasks", __dir__)
      Rake.add_rakelib(tasks_path)
    end
  end
end

require_relative "geolexica/configuration"
require_relative "geolexica/concept_page"
require_relative "geolexica/concept_serializer"
require_relative "geolexica/concepts_generator"
require_relative "geolexica/filters"
require_relative "geolexica/glossary"
require_relative "geolexica/hooks"
require_relative "geolexica/meta_pages_generator"

Jekyll::Geolexica::Hooks.register_all_hooks
