module CustomActiveRecordObserver
  module Rules
    class BaseRule
      attr_reader :block

      def initialize(block)
        @block = block
      end

      def call(target)
        block.call(target)
      end

      def allowed?(changes)
        raise NotImplementedError
      end
    end
  end
end
