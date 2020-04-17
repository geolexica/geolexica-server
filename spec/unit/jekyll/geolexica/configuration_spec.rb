# (c) Copyright 2020 Ribose Inc.
#

RSpec.describe ::Jekyll::Geolexica::Configuration do
  let(:described_module) { described_class }

  let(:wrapper) do
    wrapper = OpenStruct.new(site: fake_site)
    wrapper.extend(described_module)
    wrapper
  end

  let(:fake_site) do
    instance_double(
      Jekyll::Site,
      config: fake_config,
      source: fake_site_source,
    )
  end

  let(:fake_config) { load_plugin_config }
  let(:fake_site_source) { "/some/path" }
  let(:fake_geolexica_config) { fake_config["geolexica"] }

  describe "#glossary_config" do
    subject { wrapper.method(:glossary_config) }

    it "returns a Geolexica configuration" do
      fake_geolexica_config.replace({some: "entries"})
      expect(subject.()).to eq(fake_geolexica_config)
    end

    it "has some sensible defaults" do
      expect(subject.()).to be_a(Hash)
      expect(subject.()).not_to be_empty
    end
  end

  describe "#concepts_glob" do
    subject { wrapper.method(:concepts_glob) }

    it "returns a configured glob path to concepts" do
      fake_geolexica_config.replace({"concepts_glob" => "./some/glob/*"})
      expect(subject.()).to eq("#{fake_site_source}/some/glob/*")
    end

    it "has some sensible defaults" do
      expect(subject.()).to be_a(String) & match(/\*/)
    end
  end

  describe "term languages" do
    specify "are configurable in Geolexica, and have sensible defaults" do
      langs = fake_geolexica_config["term_languages"]
      expect(langs).to be_an(Array) & include("eng")
    end
  end

  def load_plugin_config
    path = File.expand_path("../../../../_config.yml", __dir__)
    yaml = File.read(path)
    YAML.load(yaml)
  end
end
