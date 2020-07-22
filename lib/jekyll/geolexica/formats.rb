# (c) Copyright 2020 Ribose Inc.
#

module Jekyll
  module Geolexica
    FormatDefinition = Struct.new(:setting_name, keyword_init: true)

    FORMATS = {
      html: {setting_name: "html"},
      json: {setting_name: "json"},
      jsonld: {setting_name: "json-ld"},
      tbx: {setting_name: "tbx-iso-tml"},
      turtle: {setting_name: "turtle"},
      yaml: {setting_name: "yaml"},
    }.
      transform_values { |v| FormatDefinition.new(**v).freeze }.
      freeze
  end
end
