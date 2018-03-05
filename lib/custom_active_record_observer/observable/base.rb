module CustomActiveRecordObserver
  module Observable
    # The base module which is included to all classes that are observed.
    # It adds AR after commit callbacks to class instances and handles
    # the results with <tt>CustomActiveRecordObserver::Handler</tt>
    module Base
      extend ActiveSupport::Concern

      included do
        after_commit -> { CustomActiveRecordObserver::Handler.(self, :create, previous_changes) }, on: :create
        after_commit -> { CustomActiveRecordObserver::Handler.(self, :update, previous_changes) }, on: :update
        after_commit -> { CustomActiveRecordObserver::Handler.(self, :destroy, previous_changes) }, on: :destroy
      end
    end
  end
end
