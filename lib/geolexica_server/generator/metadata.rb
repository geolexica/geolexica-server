# frozen_string_literal: true

module GeolexicaServer
  module Generator
    # Class for generating metadata of the glossary
    class Metadata < Base
      def initialize(options)
        super

        @concepts_dir = "#{@glossary_path}/concepts/*.yaml"
        @output_file_name = "metadata.yaml"
        @terms = []
      end

      def generate
        populate_terms

        term_count = @terms.map { |t| t.keys.length - 2 }.sum

        meta = {
          "concept_count" => @terms.length,
          "term_count" => term_count,
          "version" => "20220530"
        }

        write_metadata_to_output_file(meta)

        puts "Done."
      end

      private

      def populate_terms
        Dir[@concepts_dir].map do |yaml_file|
          @terms << YAML.safe_load(IO.read(yaml_file))
          puts "Processing #{yaml_file}"
        end
      end

      def write_metadata_to_output_file(meta)
        File.open(@output_file_name, "w") do |file|
          file.write(meta.to_yaml)
        end
      end
    end
  end
end
