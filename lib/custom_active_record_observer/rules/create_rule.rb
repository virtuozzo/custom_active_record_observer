module CustomActiveRecordObserver
  module Rules
    class CreateRule < BaseRule
      def allowed?(changes)
        true
      end
    end
  end
end

