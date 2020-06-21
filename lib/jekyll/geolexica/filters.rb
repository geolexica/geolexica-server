# (c) Copyright 2020 Ribose Inc.
#

module Jekyll
  module Geolexica
    module Filters
      def glossarize(input)
        FieldRenderer.new(site).render(input)
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Geolexica::Filters)
