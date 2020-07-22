# (c) Copyright 2020 Ribose Inc.
#

module Jekyll
  module Geolexica
    FORMATS = {
      html: {setting_name: "html"},
      json: {setting_name: "json"},
      jsonld: {setting_name: "json-ld"},
      tbx: {setting_name: "tbx-iso-tml"},
      turtle: {setting_name: "turtle"},
      yaml: {setting_name: "yaml"},
    }.deep_freeze
  end
end
