# (c) Copyright 2020 Ribose Inc.
#

module Jekyll
  module Geolexica
    FormatDefinition = Struct.new(:setting_name, :page_class_name,
      :collection_name, keyword_init: true)

    # Adding a new format requires defining a new ConceptPage subclass,
    # and appending this hash.
    FORMATS = {
      html: {
        setting_name: "html",
        page_class_name: "ConceptPage::HTML",
        collection_name: "",
      },
      json: {
        setting_name: "json",
        page_class_name: "ConceptPage::JSON",
        collection_name: "",
      },
      jsonld: {
        setting_name: "json-ld",
        page_class_name: "ConceptPage::JSONLD",
        collection_name: "",
      },
      tbx: {
        setting_name: "tbx-iso-tml",
        page_class_name: "ConceptPage::TBX",
        collection_name: "",
      },
      turtle: {
        setting_name: "turtle",
        page_class_name: "ConceptPage::Turtle",
        collection_name: "",
      },
      yaml: {
        setting_name: "yaml",
        page_class_name: "ConceptPage::YAML",
        collection_name: "",
      },
    }.
      transform_values { |v| FormatDefinition.new(**v).freeze }.
      freeze
  end
end
