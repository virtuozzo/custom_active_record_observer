module CustomActiveRecordObserver
  module Rules
    class UpdateRule < BaseRule
      attr_reader :attribute, :pattern

      def initialize(block, attribute: nil, pattern: nil)
        super(block)

        if pattern.is_a?(Array) && pattern.size != 2
          raise ArgumentError, "#{ pattern } is expected to be an array of two elements"
        end

        @attribute = attribute
        @pattern = pattern
      end

      def allowed?(changes)
        attribute &&
          changes.has_key?(attribute) &&
          matches_pattern?(*changes.fetch(attribute))
      end

      private

      def matches_pattern?(value_was, value)
        return true unless pattern # no pattern => allowed for all

        pattern.first === value_was && pattern.last === value
      end
    end
  end
end
