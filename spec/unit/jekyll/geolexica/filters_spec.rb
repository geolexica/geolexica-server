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
end
