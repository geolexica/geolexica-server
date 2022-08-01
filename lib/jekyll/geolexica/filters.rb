# (c) Copyright 2020 Ribose Inc.
#

module Jekyll
  module Geolexica
    module Filters
      # Renders authoritative source hash as HTML.
      #
      # @param input [Hash] authoritative source hash.
      # @return [String]
      #
      # TODO Maybe support string inputs.
      def display_authoritative_source(input)
        ref, clause, link = input["origin"].values_at("ref", "clause", "link") rescue nil

        return "" if ref.nil? && link.nil?

        ref_caption = escape_once(ref || link)
        ref_part = link ? %[<a href="#{link}">#{ref_caption}</a>] : ref_caption

        clause_part = clause && escape_once(clause)

        [ref_part, clause_part].compact.join(", ")
      end

      def display_terminological_data(term)
        result = []

        result << "&lt;#{term['usage_info']}&gt;" if term["usage_info"]
        result << extract_grammar_info(term) if term["grammar_info"]
        result << term["geographical_area"]&.upcase if term["geographical_area"]

        result.unshift(",") if result.compact.size.positive?

        result.compact.join(" ")
      end

      def extract_grammar_info(term)
        grammar_info = []

        term["grammar_info"]&.each do |info|
          grammar_info << info["gender"]&.join(", ")
          grammar_info << info["number"]&.join(", ")
          grammar_info << extract_parts_of_speech(info)
        end

        grammar_info.join(" ")
      end

      def extract_parts_of_speech(grammar_info)
        parts_of_speech = grammar_info.dup || {}

        %w[number gender].each do |key|
          parts_of_speech.delete(key)
        end

        parts_of_speech
          .select { |_key, value| value }
          .keys
          .compact
          .join(", ")
      end

      ABBREVIATION_TYPES = %w[
        truncation
        acronym
        initialism
      ].freeze

      # check if the given term is an abbreviation or not
      def abbreviation?(term)
        ABBREVIATION_TYPES.include?(term)
      end

      def get_authoritative(sources)
        sources&.find { |source| source["type"] == "authoritative" }
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Geolexica::Filters)
