# frozen_string_literal: true

require "relaton"

module GeolexicaServer
  module Generator
    # Class for generating bibliography of the glossary
    class Bibliography < Base
      def initialize(options)
        super

        @input_file = "#{@glossary_path}/bibliography.yaml"
        @output_dir = "bibliography"

        @bibliography_map = YAML.load_file(@input_file)
        @db = Relaton::Db.new(nil, nil)
      end

      def generate
        Dir.mkdir(@output_dir) unless File.directory?(@output_dir)

        @bibliography_map.each do |name, identifier|
          bib =
            @db.fetch(identifier["reference"]) ||
            user_defined_bib(identifier)

          file_path = "#{@output_dir}/#{name}.yaml"
          File.write(file_path, bib.to_yaml)
        end
      end

      private

      def user_defined_bib(identifier)
        {
          "user_defined" => true,
          "reference" => identifier["reference"],
          "link" => identifier["link"],
        }.compact
      end
    end
  end
end
