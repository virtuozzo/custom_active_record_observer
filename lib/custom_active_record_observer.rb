require 'active_support/dependencies'

module CustomActiveRecordObserver
  require_relative 'custom_active_record_observer/all'

  mattr_accessor :schema
  @@schema = Schema.new

  def self.observe(*class_names, handler:, &block)
    class_names.each do |class_name|
      DSL.new(block).actions_and_rules.each do |(action, rule)|
        schema.add_rule(class_name, action, rule, handler)
      end
    end
  end
end
