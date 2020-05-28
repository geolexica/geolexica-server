# (c) Copyright 2020 Ribose Inc.
#

RSpec.describe ::Jekyll::Geolexica::RDFBuilder do
  subject { rdfb }

  let(:rdfb) { described_class.new(concept_10, site) }
  let(:concept_10) { load_concept_fixture("concept-10.yaml") }
  let(:site) { fake_site }

  let(:fake_site) do
    instance_double(
      Jekyll::Site,
      config: fake_config,
      data: {"lang" => fake_lang_data},
    )
  end

  let(:fake_config) { load_yaml("_config.yml") }
  let(:fake_lang_data) { load_yaml("_data/lang.yaml") }

  specify "#site returns Jekyll::Site instance" do
    expect(rdfb.site).to be(site)
  end

  specify "#glossary_concept returns the concept that graph describes" do
    expect(rdfb.glossary_concept).to be(concept_10)
  end

  specify "#data returns the concept hash that graph describes" do
    expect(rdfb.data).to be(concept_10.data)
  end

  specify "#termid returns the term ID of the concept that graph describes" do
    expect(rdfb.termid).to be(10)
  end

  specify "#languages returns a list of supported languages that concept is " +
    "translated to" do
    # Concept 10 is translated to: eng, ara, dan, ger, kor, rus, spa, swe.
    replace_configured_languages! "eng", "kor", "cpf", "pol"
    expect(rdfb.languages).to be_an(Array) & contain_exactly("eng", "kor")
  end

  specify "#build_graph returns a non-empty RDF Graph instance" do
    retval = rdfb.build_graph
    expect(retval).to be_kind_of(::RDF::Graph)
    expect(retval).not_to be_empty
  end

  describe "generated graph" do
    let(:graph) { rdfb.build_graph }

    let(:concept_10_subject) do
      RDF::URI.new("https://www.geolexica.org/concepts/10/#")
    end

    it "describes concept 10" do
      expect(graph.subjects).to include(concept_10_subject)
    end

    it "states that concept is a SKOS concept" do
      expect(value_for(RDF.type).to_s).to match(%r[skos/core#Concept])
    end

    it "states some label for concept" do
      expect(value_for(RDF::Vocab::SKOS.prefLabel)).not_to be_nil
    end

    def value_for(predicate)
      graph.first([concept_10_subject, predicate, nil])&.object
    end
  end

  def load_yaml(path_from_root)
    root = File.expand_path("../../../..", __dir__)
    path = File.expand_path(path_from_root, root)
    yaml = File.read(path)
    YAML.load(yaml)
  end

  def replace_configured_languages!(*langs)
    fake_config["geolexica"]["term_languages"] = langs
  end
end
