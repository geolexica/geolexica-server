# frozen_string_literal: true

require "spec_helper"

RSpec.describe GeolexicaServer::Generator::Bibliography do
  describe "#user_defined_bib" do
    let(:options) { { "config_file_path" => fixture_path("config.yaml") } }
    subject { described_class.new(options).send(:user_defined_bib, identifier) }

    context "when link is present" do
      let(:identifier) { { "reference" => "ref_1", "link" => "http://www.abc.com" } }
      let(:expected_value) do
        {
          "user_defined" => true,
          "reference" => "ref_1",
          "link" => "http://www.abc.com",
        }
      end

      it { is_expected.to eq(expected_value) }
    end

    context "when link is not present" do
      let(:identifier) { { "reference" => "ref_1" } }
      let(:expected_value) do
        {
          "user_defined" => true,
          "reference" => "ref_1",
        }
      end

      it { is_expected.to eq(expected_value) }
    end
  end
end
