# (c) Copyright 2020 Ribose Inc.
#

RSpec.describe Jekyll::Geolexica::Filters do
  let(:wrapper) do
    w = Object.new
    w.extend(described_class)
    w
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

    it "returns 'ref' as link and ', clause' as string " \
      "when ref, clause, and link are given" do
      input = { "origin" => { "ref" => ref, "clause" => clause, "link" => link } }
      retval = subject.call(input)
      expect(retval).to eq(%(<a href="#{link}">!#{ref}!</a>, !#{clause}!))
    end

    it "returns 'ref, clause' as string when ref, and clause are given" do
      input = { "origin" => { "ref" => ref, "clause" => clause } }
      retval = subject.call(input)
      expect(retval).to eq("!#{ref}!, !#{clause}!")
    end

    it "returns 'ref' as link when ref, and link are given" do
      input = { "origin" => { "ref" => ref, "link" => link } }
      retval = subject.call(input)
      expect(retval).to eq(%(<a href="#{link}">!#{ref}!</a>))
    end

    it "returns 'ref' as string when ref, and clause are given" do
      input = { "origin" => { "ref" => ref } }
      retval = subject.call(input)
      expect(retval).to eq("!#{ref}!")
    end

    it "returns 'link' as link when only link is given" do
      input = { "origin" => { "link" => link } }
      retval = subject.call(input)
      expect(retval).to eq(%(<a href="#{link}">!#{link}!</a>))
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

  describe "#abbreviation?" do
    subject { wrapper.method(:abbreviation?) }

    it "returns true if term is valid abbreviation" do
      expect(subject.call("truncation")).to eq(true)
      expect(subject.call("acronym")).to eq(true)
      expect(subject.call("initialism")).to eq(true)
    end

    it "returns false if term is not a valid abbreviation" do
      expect(subject.call("invalid")).to eq(false)
      expect(subject.call("hello_world")).to eq(false)
    end
  end

  describe "#get_authoritative" do
    subject { wrapper.method(:get_authoritative) }

    it "returns authoritative source if available in given sources" do
      sources = [
        { "type" => "authoritative" },
        { "type" => "lineage" }
      ]

      expect(subject.call(sources)).to eq(sources[0])
    end

    it "returns nil if authoritative source is not in given sources" do
      sources = [
        { "type" => "lineage" }
      ]

      expect(subject.call(sources)).to eq(nil)
    end

    it "returns nil if given sources are nil" do
      expect(subject.call(nil)).to eq(nil)
    end
  end
end
