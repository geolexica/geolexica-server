# (c) Copyright 2020 Ribose Inc.
#

require "jekyll"

# Unfortunately, Zeitwerk::Loader.for_gem doesn't work well when gem's main
# namespace is compound.
require "zeitwerk"
loader = Zeitwerk::Loader.new
loader.tag = "jekyll-geolexica"
loader.push_dir(File.join(__dir__, "geolexica"), namespace: Jekyll::Geolexica)
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.setup

module Jekyll
  module Geolexica
    # Loads Rake tasks which are provided in this gem.
    #
    # In order to load these tasks, following lines should be added to given
    # site's Rakefile:
    #
    #   require "jekyll-geolexica"
    #   ::Jekyll::Geolexica.load_tasks
    def self.load_tasks
      tasks_path = File.expand_path("../tasks", __dir__)
      Rake.add_rakelib(tasks_path)
    end
  end
end

# Jekyll-Geolexica must be loaded eagerly because Jekyll has no other way
# to learn about gem's features.
loader.eager_load

Jekyll::Geolexica::Hooks.register_all_hooks
