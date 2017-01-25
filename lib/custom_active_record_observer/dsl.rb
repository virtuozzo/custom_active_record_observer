require_relative 'rule'

module CustomActiveRecordObserver
  class DSL
    def initialize(block)
      instance_exec(&block)
    end

    def actions_and_rules
      @actions_and_rules ||= []
    end

    def create(&block)
      store(:create, Rule.new(block))
    end

    def destroy(&block)
      store(:destroy, Rule.new(block))
    end

    def on_add(*attributes, &block)
      attributes.each do |attribute|
        store(:update, Rule.new(block, attribute: attribute, condition: :on_add))
      end
    end

    def on_remove(*attributes, &block)
      attributes.each do |attribute|
        store(:update, Rule.new(block, attribute: attribute, condition: :on_remove))
      end
    end

    def on_change(*attributes, &block)
      attributes.each do |attribute|
        store(:update, Rule.new(block, attribute: attribute, condition: :on_change))
      end
    end

    private

    def store(action, rule)
      actions_and_rules << [action, rule]
    end
  end
end
