module CustomActiveRecordObserver
  class Engine < ::Rails::Engine
    isolate_namespace CustomActiveRecordObserver

    config.to_prepare do
      CustomActiveRecordObserver.schema.freeze

      CustomActiveRecordObserver::ModelsExtender.(CustomActiveRecordObserver.schema)
    end
  end
end
