module CustomActiveRecordObserver
  class DSL
    def initialize(block)
      instance_exec(&block)
    end

    def actions_and_rules
      @actions_and_rules ||= []
    end

    def on_create(&block)
      store(:create, Rules::CreateRule.new(block))
    end

    def on_destroy(&block)
      store(:destroy, Rules::DestroyRule.new(block))
    end

    def on_update(*attributes, &block)
      pattern = attributes.pop if attributes.last.is_a?(Array)

      attributes.each do |attribute|
        store(:update, Rules::UpdateRule.new(block, attribute: attribute, pattern: pattern))
      end
    end

    def on_add(*attributes, &block)
      on_update(*attributes.push([nil, NotNil]), &block)
    end

    def on_remove(*attributes, &block)
      on_update(*attributes.push([NotNil, nil]), &block)
    end

    def on_change(*attributes, &block)
      on_update(*attributes.push([NotNil, NotNil]), &block)
    end

    private

    def store(action, rule)
      actions_and_rules << [action, rule]
    end
  end
end
