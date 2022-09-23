# frozen_string_literal: true

require "spec_helper"

RSpec.describe GeolexicaServer::Generator::Base do
  describe "initialize" do
    subject { described_class.new(options) }

    context "glossary path is not present" do
      let(:options) { { "config_file_path" => fixture_path("abc.yaml") } }

      it "should raise error" do
        expect { subject }.to raise_error(StandardError)
      end
    end

    context "glossary path is present" do
      let(:options) { { "config_file_path" => fixture_path("config.yaml") } }

      it "should not raise error" do
        expect { subject }.not_to raise_error
      end
    end
  end
end
