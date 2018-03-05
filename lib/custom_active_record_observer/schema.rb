module CustomActiveRecordObserver
  class Schema
    attr_reader :schema

    delegate :fetch, to: :schema

    # {
    #   'User' =>
    #     {
    #       update: [[rule_1, handler], [rule_2, handler]],
    #       create: [[rule_3, handler]]
    #     }
    #   'Article' =>
    #     {
    #       destroy: [[rule5, handler]],
    #     }
    # }
    def initialize(schema = {})
      @schema = schema
    end

    def add_rule(class_name, action, rules, handler)
      unless class_name.is_a?(Symbol)
        class_name = class_name.to_s.to_sym
      end

      schema[class_name] ||= {}
      schema[class_name][action] ||= []

      Array(rules).each do |rule|
        schema[class_name][action] << [rule, handler]
      end
    end

    def get_rules(class_name, action, raw_changes = {})
      changes = raw_changes.symbolize_keys

      schema.fetch(class_name.to_sym, {}).
             fetch(action, []).select do |(rule, handler)|
        rule.allowed?(changes)
      end
    end

    def classes
      schema.keys.map { |name| name.to_s.constantize }
    end
  end
end
