module CustomActiveRecordObserver
  module ModelsExtender
    def self.call(schema)
      schema.classes.map(&:base_class).uniq.each do |base_class|
        base_class.include(CustomActiveRecordObserver::Observable)
      end
    end
  end
end
