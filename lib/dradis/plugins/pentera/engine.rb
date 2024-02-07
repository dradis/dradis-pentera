module Dradis::Plugins::Pentera
  class Engine < ::Rails::Engine
    isolate_namespace Dradis::Plugins::Pentera

    include ::Dradis::Plugins::Base
    description 'Processes Pentera exports'
    provides :upload
  end
end
