# @title CustomActiveRecordObserver::DSL
module CustomActiveRecordObserver
  # A main methods that are supposed to be used within CustomActiveRecordObserver
  #
  # @author Virtuozzo
  class DSL
    attr_reader :actions_and_rules

    # @attr_reader [Array] actions_and_rules the resulting list of applied rules
    def initialize(block)
      @actions_and_rules = []

      instance_exec(&block)
    end

    # Executes the code inside a block after the record is *created*
    def on_create(&block)
      store(:create, Rules::CreateRule.new(block))
    end

    # Executes the code inside a block after the record is *destroyed*
    def on_destroy(&block)
      store(:destroy, Rules::DestroyRule.new(block))
    end

    # @param attributes [Symbols] - list of attribute names (e.g. :user_id, :user_group_id ...)
    # @param values [Array(2)] - array of two values (before and after)
    # Launches code inside a block if an object changes any of attributes according
    # to the pattern which is described in the brackets (value before -> value after)
    #
    # This uses `===` method to compare values.
    # @example Add hook on update any of attributes according to the pattern
    #  on_update :address, :phone_number, [CustomActiveRecordObserver::NotNill,
    #                                      CustomActiveRecordObserver::NotNill] do |user|
    #    # notify system that user contact info was changed
    #  end
    #
    # Will be launched only if user_group_id was changed from `nil` to anything but nil.
    # in the array [] there are two values that are compared with the real changes
    # to detect if they maches.
    # @example Track nil -> not nill changes of user_group_id attribute
    #   on_update :user_group_id, [nil, CustomActiveRecordObserver::NotNill] do |user|
    #     # here we know that some user_group was assigned to user
    #   end
    # @example Other examples of usage:
    #   on_update :user_group_id, [1, 2] { |user| ... }
    #   on_update :user_group_id, [1, Integer] { |user| ... }
    def on_update(*attributes, &block)
      pattern = attributes.pop if attributes.last.is_a?(Array)

      attributes.each do |attribute|
        store(:update, Rules::UpdateRule.new(block, attribute: attribute, pattern: pattern))
      end
    end

    # Executes the code inside a block when the specific attributes are *updated*
    # from <tt>nil</tt> to some <tt>not nil</tt> value
    # @example
    #   on_add :user_group_id do |user|
    #     # here we know that user_group_id was nil, but now it is not
    #   end
    def on_add(*attributes, &block)
      on_update(*attributes.push([nil, NotNil]), &block)
    end

    # Executes the code inside a block when the specific attributes are *updated*
    # from some <tt>not nil</tt> value to <tt>nil</tt>
    # @example
    #   on_remove :user_group_id do |user|
    #     # here we know that user_group_id is equal to nil now
    #   end
    def on_remove(*attributes, &block)
      on_update(*attributes.push([NotNil, nil]), &block)
    end

    # Executes the code inside a block when the specific attributes are *updated*
    # from some <tt>not nil</tt> to another <tt>not nil</tt>
    # @example
    #   on_change :user_group_id do |user|
    #     # user was assigned to another user group
    #   end
    def on_change(*attributes, &block)
      on_update(*attributes.push([NotNil, NotNil]), &block)
    end

    private

    def store(action, rule)
      actions_and_rules << [action, rule]
    end
  end
end
