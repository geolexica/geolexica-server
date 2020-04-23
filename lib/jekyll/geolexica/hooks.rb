module Jekyll
  module Geolexica
    module Hooks
      module_function

      def register_all_hooks
        Jekyll::Hooks.register :site, :after_init, &method(:initialize_glossary)
      end

      # Adds Jekyll::Site#glossary method, and initializes an empty glossary.
      def initialize_glossary(site)
        site.class.attr_reader :glossary
        site.instance_variable_set "@glossary", Glossary.new(site)
      end
    end
  end
end
