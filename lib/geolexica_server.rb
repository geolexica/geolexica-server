# frozen_string_literal: true

require "jekyll"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.setup

module GeolexicaServer
  # Loads Rake tasks which are provided in this gem.
  #
  # In order to load these tasks, following lines should be added to given
  # site's Rakefile:
  #
  #   require "geolexica_server"
  #   GeolexicaServer.load_tasks
  def self.load_tasks
    tasks_path = File.expand_path("../tasks", __dir__)
    Rake.add_rakelib(tasks_path)
  end

  DEFAULT_CONFIG_FILE_PATH = "./_config.yaml"
end
