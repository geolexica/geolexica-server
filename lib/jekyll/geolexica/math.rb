# (c) Copyright 2020 Ribose Inc.
#

require "asciimath"
require "mathml2asciimath"
require "open3"
require "singleton"

module Jekyll
  module Geolexica
    module Math

      class ConversionError < StandardError
        attr_reader :expression, :from, :to, :details, :result

        def initialize(expression, from:, to:, result: nil, details: nil)
          @expression = expression
          @from = from
          @to = to
          @result = result
          @details = details
        end

        def fatal?
          result.nil?
        end

        def message
          head = fatal? ?
            "Could not convert" :
            "There were some difficulties with converting"

          "#{head} formula from #{from} to #{to}"
        end
      end

      # A helper class which contains mathematical formulae converter logic.
      class Converter
        include Singleton

        def convert(expression, from:, to:)
          public_send("#{from}_to_#{to}", expression)
        end

        def asciimath_to_mathml(expression)
          AsciiMath.parse(expression).to_mathml
        end

        # TODO In fact it is quite difficult to tell when the error should be
        # considered fatal, because latexmlmath exit status is zero even if
        # warnings or errors are printed.  For this reason, we test all of
        # following: exit status, stdout length, stderr length, and presence of
        # "Error:" substring in the stderr.
        def latexmath_to_mathml(expression)
          cmd = "latexmlmath --strict --preload=amsmath --preload=amssymb -- -"

          cout, cerr, exit_status = Open3.capture3(cmd, stdin_data: expression)

          case
          when exit_status.success? && !cout.empty? && cerr.empty? # success
            return cout
          when exit_status.success? && !cout.empty? && /^Error:/ !~ cerr
            # warnings
            raise ConversionError.new(expression,
              from: :latexmath, to: :mathml, details: cerr, result: cout)
          else # errors
            raise ConversionError.new(expression,
              from: :latexmath, to: :mathml, details: cerr)
          end
        end

        def mathml_to_asciimath(expression)
          MathML2AsciiMath.m2a(expression)
        end
      end

      module_function

      # Converts mathematical formula from one notation to another.
      #
      # @param expression [String] expression to be converted
      # @param from [Symbol] input format
      # @param to [Symbol] output format
      #
      # @return [String] converted expression
      def convert(expression, from:, to:)
        Converter.instance.convert(expression, from: from, to: to)
      end
    end
  end
end
