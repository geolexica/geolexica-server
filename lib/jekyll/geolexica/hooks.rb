module Jekyll
  module Geolexica
    module Hooks
      module_function

      def register_all_hooks
        Jekyll::Hooks.register :site, :after_init, &method(:initialize_glossary)
        Jekyll::Hooks.register :site, :post_read, &method(:load_glossary)
      end

      # Adds Jekyll::Site#glossary method, and initializes an empty glossary.
      def initialize_glossary(site)
        site.class.attr_reader :glossary
        site.instance_variable_set "@glossary", Glossary.new(site)
      end

      # Loads concept data into glossary.
      def load_glossary(site)
        site.glossary.load_glossary
      end
    end
  end
end
