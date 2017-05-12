module CustomActiveRecordObserver
  module Rules
    class DestroyRule < BaseRule
      def allowed?(changes)
        true
      end
    end
  end
end

