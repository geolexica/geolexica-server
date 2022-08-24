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

        source = [ref_part, clause_part].compact.join(", ")

        modification = input["modification"]
        return source unless modification

        "#{source}, modified -- #{modification}"
      end

      def debug(param)
        require "pry"
        binding.pry if param
      end

      def concepts_url(base_url)
        return if !base_url || base_url.empty?

        if base_url.end_with?("/")
          "#{base_url}concepts/"
        else
          "#{base_url}/concepts/"
        end
      end

      def extract_concept_id(url)
        return if !url || url.empty?

        url.split("/").last
      end

      REFERENCE_REGEX = /{{(urn:[^,}]*),?([^,}]*),?([^}]*)?}}/.freeze

      def resolve_reference_to_links(text)
        text.gsub(REFERENCE_REGEX) do |reference|
          urn = Regexp.last_match[1]

          if !urn || urn.empty?
            reference
          else
            link_tag_from_urn(urn, Regexp.last_match[2], Regexp.last_match[3])
          end
        end
      end

      def link_tag_from_urn(urn, term_referenced, term_to_show)
        clause = urn.split(":").last
        term_to_show = term_to_show.empty? ? term_referenced : term_to_show

        "<a href=\"/concepts/#{clause}\">#{term_to_show}<\/a>"
      end

      def display_terminological_data(term)
        result = []

        result << "&lt;#{term['usage_info']}&gt;" if term["usage_info"]
        result << extract_grammar_info(term)
        result << term["geographical_area"]&.upcase

        result.unshift(",") if result.compact.size.positive?

        result.compact.join(" ")
      end

      def extract_grammar_info(term)
        return unless term["grammar_info"]

        grammar_info = []

        term["grammar_info"].each do |info|
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
        ABBREVIATION_TYPES.include?(term["type"])
      end

      def preferred?(term)
        term["normative_status"] == "preferred"
      end

      def deprecated?(term)
        term["normative_status"] == "deprecated"
      end

      def get_authoritative(sources)
        sources&.find { |source| source["type"] == "authoritative" }
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Geolexica::Filters)
