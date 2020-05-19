# (c) Copyright 2020 Ribose Inc.
#

RSpec.describe ::Jekyll::Geolexica::ConceptSerializer do
  let(:concept_10) { load_concept_fixture("concept-10.yaml") }

  let(:fake_site) do
    instance_double(Jekyll::Site)
  end

  it "initializes with a concept and site" do
    instance = described_class.new(concept_10, fake_site)
    expect(instance).to be_kind_of(described_class)
    expect(instance.termid).to eq(concept_10.termid)
    expect(instance.data).to eq(concept_10.data)
    expect(instance.site).to be(fake_site)
  end
end
