require_relative 'observable'

module CustomActiveRecordObserver
  class Engine < ::Rails::Engine
    isolate_namespace CustomActiveRecordObserver

    config.after_initialize { CustomActiveRecordObserver.extend_observable_models }
  end
end
