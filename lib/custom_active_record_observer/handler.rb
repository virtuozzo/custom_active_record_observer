module CustomActiveRecordObserver
  module Handler
    def self.call(target, action, _changes, schema: CustomActiveRecordObserver.schema)
      # Some AR libraries reload AR object in the callbacks.
      # Hence, ActiveModel::Dirty model changes hash becomes empty.
      # @_active_record_observer_changes is needed to that changes not be missed
      changes =
        (target.instance_variable_get(:@_active_record_observer_changes) || {}).merge(_changes)

      ActiveRecord::Base.transaction do
        schema.
          get_rules(target.class.name, action, changes).
          each { |rule, handler| handler.(rule.(target)) }
      end
    end
  end
end
