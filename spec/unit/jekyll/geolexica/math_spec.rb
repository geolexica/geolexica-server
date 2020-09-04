# (c) Copyright 2020 Ribose Inc.
#

RSpec.describe ::Jekyll::Geolexica::Math do
  subject { described_class }

  describe "#convert" do
    subject { described_class.method(:convert) }

    let(:converter_dbl) { described_class::Converter.clone }

    before { stub_const described_class::Converter.name, converter_dbl }

    it "performs specified conversion by using Converter helper object" do
      converter_dbl.define_method "format1_to_format2" do |expr|
        "converted_#{expr}"
      end

      retval = subject.("expr", from: :format1, to: :format2)

      expect(retval).to eq("converted_expr")
    end
  end
end
