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
        ref, clause, link = input.values_at("ref", "clause", "link") rescue nil

        return "" if ref.nil? && link.nil?

        ref_caption = escape_once(ref || link)
        ref_part = link ? %[<a href="#{link}">#{ref_caption}</a>] : ref_caption

        clause_part = clause && escape_once(clause)

        [ref_part, clause_part].compact.join(", ")
      end

      # Converts various mathematical formulae formats to MathML.
      #
      # TODO Render math blocks properly.
      # TODO Make these tags configurable.
      def parse_math(input)
        input.gsub(%r(
          (?<open>\\\()  (?<expr>.*?)  \\\) | # LaTeX inline
          (?<open>\\\[)  (?<expr>.*?)  \\\] | # LaTeX block
          (?<open>`)     (?<expr>.*?)  `      # AsciiMath
        )x) do
          case $~["open"]
          when '\(' then src_format = :latexmath
          when '\[' then src_format = :latexmath
          when '`'  then src_format = :asciimath
          end

          Math.convert($~["expr"], from: src_format, to: :mathml)
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Geolexica::Filters)
