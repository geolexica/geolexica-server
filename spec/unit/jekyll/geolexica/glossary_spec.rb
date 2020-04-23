# (c) Copyright 2020 Ribose Inc.
#

RSpec.describe ::Jekyll::Geolexica::Glossary do
  subject { instance }

  let(:instance) { described_class.new(fake_site) }
  let(:fake_site) { instance_double(Jekyll::Site) }

  it { is_expected.to respond_to(:each_concept) }
  it { is_expected.to respond_to(:each_termid) }
end
