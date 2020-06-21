# (c) Copyright 2020 Ribose Inc.
#

module Jekyll
  module Geolexica
    class FieldRenderer
      include Configuration

      attr_reader :site

      def initialize(site, **options)
        @site = site
      end

      def filters
        %i[escape]
      end

      def render(input)
        filters.reduce(input) do |acc, filter|
          send(filter, acc)
        end
      end

      private

      # Filter methods

      def escape(input)
        input # TODO
      end
    end
  end
end
