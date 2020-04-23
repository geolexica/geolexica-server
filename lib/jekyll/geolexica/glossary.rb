# (c) Copyright 2020 Ribose Inc.
#

module Jekyll
  module Geolexica
    class Glossary < Hash
      include Configuration

      attr_reader :site

      alias_method :each_concept, :each_value
      alias_method :each_termid, :each_key

      def initialize(site)
        @site = site
      end
    end
  end
end
