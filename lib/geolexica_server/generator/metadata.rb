# frozen_string_literal: true

module GeolexicaServer
  module Generator
    # Class for generating metadata of the glossary
    class Metadata < Base
      def initialize(options)
        super

        @concepts_dir = "#{@glossary_path}/concepts/*.yaml"
        @output_file_name = "metadata.yaml"
      end

      def generate
        terms = extract_terms

        File.open(@output_file_name, "w") do |file|
          file.write(metadata(terms).to_yaml)
        end

        puts "Done."
      end

      private

      def extract_terms
        terms = []

        Dir[@concepts_dir].map do |yaml_file|
          terms << YAML.safe_load(IO.read(yaml_file))
          puts "Processing #{yaml_file}"
        end

        terms
      end

      def metadata(terms)
        {
          "concept_count" => terms.length,
          "term_count" => terms.sum { |t| t.keys.length - 2 },
          "version" => "20220530",
        }
      end
    end
  end
end
