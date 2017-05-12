module CustomActiveRecordObserver
  module Handler
    def self.call(target, action, changes, schema: CustomActiveRecordObserver.schema)
      ActiveRecord::Base.transaction do
        schema.
          get_rules(target.class.name, action, changes).
          each { |rule, handler| handler.(rule.(target)) }
      end
    end
  end
end
