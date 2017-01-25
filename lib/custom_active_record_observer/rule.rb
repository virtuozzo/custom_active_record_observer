module CustomActiveRecordObserver
  class Rule
    attr_reader :block, :attribute, :condition

    # condition may be :on_change, :on_add, :on_remove
    def initialize(block, attribute: nil, condition: nil)
      @block = block
      @attribute = attribute
      @condition = condition
    end

    def call(target)
      block.call(target)
    end

    def allowed?(changes)
      return true unless attribute

      changes.has_key?(attribute) && allowed_condition?(*changes.fetch(attribute))
    end

    private

    def allowed_condition?(value_was, value)
      return true unless condition # no condition => allowed for all

      raise ArgumentError if value_was.nil? && value.nil? # impossible case

      condition ==
        if value_was.nil?
          :on_add
        elsif value.nil?
          :on_remove
        else
          :on_change
        end
    end
  end
end
