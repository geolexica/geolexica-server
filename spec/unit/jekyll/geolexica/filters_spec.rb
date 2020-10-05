# (c) Copyright 2020 Ribose Inc.
#

RSpec.describe Jekyll::Geolexica::Filters do
  let(:wrapper) do
    w = Object.new
    w.extend(described_class)
    w.instance_variable_set("@context", liquid_context_dbl)
    w
  end

  let(:liquid_context_dbl) do
    double(registers: { page: { path: "path/page.html" } })
  end

  describe "#display_authoritative_source" do
    subject { wrapper.method(:display_authoritative_source) }

    # Stub stock Liquid filter.
    before do
      def wrapper.escape_once(str); "!#{str}!"; end
    end

    let(:link) { "http://standards.example.test/a#chapter" }
    let(:ref) { "ISO 123:1984" }
    let(:clause) { "1.2.3" }

    it "returns 'ref' as link and ', clause' as string " +
      "when ref, clause, and link are given" do
      input = { "ref" => ref, "clause" => clause, "link" => link }
      retval = subject.call(input)
      expect(retval).to eq(%{<a href="#{link}">!#{ref}!</a>, !#{clause}!})
    end

    it "returns 'ref, clause' as string when ref, and clause are given" do
      input = { "ref" => ref, "clause" => clause }
      retval = subject.call(input)
      expect(retval).to eq("!#{ref}!, !#{clause}!")
    end

    it "returns 'ref' as link when ref, and link are given" do
      input = { "ref" => ref, "link" => link }
      retval = subject.call(input)
      expect(retval).to eq(%{<a href="#{link}">!#{ref}!</a>})
    end

    it "returns 'ref' as string when ref, and clause are given" do
      input = { "ref" => ref }
      retval = subject.call(input)
      expect(retval).to eq("!#{ref}!")
    end

    it "returns 'link' as link when only link is given" do
      input = { "link" => link }
      retval = subject.call(input)
      expect(retval).to eq(%{<a href="#{link}">!#{link}!</a>})
    end

    it "returns an empty string when only clause is given" do
      input = { "clause" => clause }
      retval = subject.call(input)
      expect(retval).to eq("")
    end

    it "returns an empty string when neither of ref, clause, and link " +
      "is given" do
      input = {}
      retval = subject.call(input)
      expect(retval).to eq("")

      input = { "comment" => "some text" }
      retval = subject.call(input)
      expect(retval).to eq("")
    end

    it "returns an empty string for nil input" do
      retval = subject.call(nil)
      expect(retval).to eq("")
    end
  end

  describe "#parse_math" do
    subject { wrapper.method(:parse_math) }

    before do
      # Suppress logger
      allow(Jekyll.logger.writer).to receive(:debug)
      allow(Jekyll.logger.writer).to receive(:error)
      allow(Jekyll.logger.writer).to receive(:info)
      allow(Jekyll.logger.writer).to receive(:warn)
    end

    it "accepts a string input and returns a string" do
      retval = subject.call("input string")
      expect(retval).to be_kind_of(String)
    end

    it "detects AsciiMath expressions and converts them to MathML" do
      input = 'Everyone knows that `pi` is roughly 3.14.'
      retval = subject.call(input)
      expect(retval).to include('<mi>&#x3C0;</mi>') | include('<mi>π</mi>')
    end

    it "detects LaTeX math expressions and converts them to MathML" do
      input = 'Everyone knows that \(\pi\) is roughly 3.14.'
      retval = subject.call(input)
      expect(retval).to include('<mi>&#x3C0;</mi>') | include('<mi>π</mi>')
    end

    it "detects LaTeX math block expressions and converts them to MathML" do
      input = 'Everyone knows that: \[\pi\] is roughly 3.14.'
      retval = subject.call(input)
      expect(retval).to include('<mi>&#x3C0;</mi>') | include('<mi>π</mi>')
    end

    it "a malformed formula does not affect other content in given string" do
      input = 'The `1+2`, the `bad one`, and the `3+4` formulas.'
      math = Jekyll::Geolexica::Math # for short

      allow(math).to receive(:convert).
        with("bad one", any_args).
        and_raise(math::ConversionError.new("bad one", from: :_, to: :_))

      allow(math).to receive(:convert).
        with("1+2", any_args).
        and_call_original

      allow(math).to receive(:convert).
        with("3+4", any_args).
        and_call_original

      retval = subject.call(input)

      # Expect text, unchanged broken formula, and converted good formulas.
      expect(retval).to include(
        "The", "and the", "formulas.",
        "the `bad one`",
        "<mn>1</mn>", "<mn>2</mn>", "<mn>3</mn>", "<mn>4</mn>", "<mo>+</mo>"
      )
    end
  end
end
