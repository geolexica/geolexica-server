# frozen_string_literal: true

require "spec_helper"

RSpec.describe GeolexicaServer::Generator::Metadata do
  let(:options) { { "config_file_path" => fixture_path("config.yaml") } }
  subject { described_class.new(options) }

  describe "#extract_terms" do
    let(:terms) { subject.send(:extract_terms) }
    let(:expected_output) do
      [
        {
          "termid" => "3.1.1.2",
          "term" => "immaterial entity",
          "eng" => {
            "terms" => [
              { "type" => "expression", "designation" => "immaterial entity" },
            ],
          },
        },
        {
          "termid" => "3.1.1.1",
          "term" => "entity",
          "eng" => {
            "terms" => [
              { "type" => "expression", "designation" => "entity" },
            ],
          }
        },
      ]
    end

    it "should return terms from concepts" do
      expect(terms).to eq(expected_output)
    end
  end

  describe "#metadata" do
    let(:terms) { subject.send(:extract_terms) }
    let(:expected_output) do
      {
        "concept_count" => 2,
        "term_count" => 2,
        "version" => "20220530",
      }
    end

    it "should return terms metadata" do
      expect(subject.send(:metadata, terms)).to eq(expected_output)
    end
  end
end
