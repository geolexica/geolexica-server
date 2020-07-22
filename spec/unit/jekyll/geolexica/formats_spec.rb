# (c) Copyright 2020 Ribose Inc.
#

RSpec.describe ::Jekyll::Geolexica::FORMATS do
  it { is_expected.to be_kind_of(Hash) }

  specify { expect(subject).to be_frozen }
  specify { expect(subject.keys).to all be_kind_of(Symbol) }
  specify { expect(subject.values).to all be_frozen }
  specify { expect(subject.values).to all respond_to(:setting_name) }
end
