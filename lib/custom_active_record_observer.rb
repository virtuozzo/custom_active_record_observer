require 'active_support/dependencies'

module CustomActiveRecordObserver
  extend self

  require_relative 'custom_active_record_observer/engine'
  require_relative 'custom_active_record_observer/dsl'
  require_relative 'custom_active_record_observer/schema'

  def observe(*class_names, handler:, &block)
    class_names.each do |class_name|
      DSL.new(block).actions_and_rules.each do |(action, rule)|
        schema.add_rule(class_name, action, rule, handler)
      end
    end
  end

  def handle(target, action, changes)
    ActiveRecord::Base.transaction do
      schema.get_rules(target.class.name, action, changes).each do |rule, handler|
        handler.call(rule.call(target))
      end
    end
  end

  def extend_observable_models
    schema.classes.each { |klass| klass.include(CustomActiveRecordObserver::Observable) }
  end

  private

  def schema
    @schema ||= Schema.new
    # Rails.application.config.custom_active_record_observer_schema
  end
end
