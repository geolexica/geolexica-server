# (c) Copyright 2020 Ribose Inc.
#

module Jekyll
  module Geolexica
    FormatDefinition = Struct.new(:setting_name, :page_class_name,
      keyword_init: true)

    FORMATS = {
      html: {
        setting_name: "html",
        page_class_name: "ConceptPage::HTML",
      },
      json: {
        setting_name: "json",
        page_class_name: "ConceptPage::JSON",
      },
      jsonld: {
        setting_name: "json-ld",
        page_class_name: "ConceptPage::JSONLD",
      },
      tbx: {
        setting_name: "tbx-iso-tml",
        page_class_name: "ConceptPage::TBX",
      },
      turtle: {
        setting_name: "turtle",
        page_class_name: "ConceptPage::Turtle",
      },
      yaml: {
        setting_name: "yaml",
        page_class_name: "ConceptPage::YAML",
      },
    }.
      transform_values { |v| FormatDefinition.new(**v).freeze }.
      freeze
  end
end
