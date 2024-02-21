module Dradis
  module Plugins
    module Pentera
      class FieldProcessor < Dradis::Plugins::Upload::FieldProcessor
        def value(args = {})
          field = args[:field]

          # fields in the template are of the form <foo>.<field>, where <foo>
          # is common across all fields for a given template (and meaningless).
          _, name = field.split('.')

          @data[name] || 'n/a'
        end
      end
    end
  end
end
