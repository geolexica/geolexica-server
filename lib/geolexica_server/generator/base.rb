# frozen_string_literal: true

require "yaml"

module GeolexicaServer
  module Generator
    # Base class for generators in GeolexicaServer
    class Base
      def self.generate(*args)
        new(*args).generate
      end

      def initialize(options = {})
        config_file_path = options["config_file_path"] || GeolexicaServer::DEFAULT_CONFIG_FILE_PATH

        @config = YAML.load_file(config_file_path)

        if @config["geolexica"].nil? || @config["geolexica"]["glossary_path"].nil?
          raise StandardError, "geolexica.glossary_path is missing in config file."
        end

        @glossary_path = @config["geolexica"]["glossary_path"]
      end
    end
  end
end
