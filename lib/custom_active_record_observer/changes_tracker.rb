module CustomActiveRecordObserver
  module ChangesTracker
    def self.[](*method_names)
      Module.new do
        method_names.each do |name|
          define_method name do |*args|
            @_active_record_observer_changes ||= {}
            @_active_record_observer_changes.merge!(previous_changes)

            super(*args)
          end
        end
      end
    end
  end
end
