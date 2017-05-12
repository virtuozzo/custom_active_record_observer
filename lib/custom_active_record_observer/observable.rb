module CustomActiveRecordObserver
  module Observable
    extend ActiveSupport::Concern

    included do
      after_commit -> { CustomActiveRecordObserver::Handler.(self, :create, previous_changes) }, on: :create
      after_commit -> { CustomActiveRecordObserver::Handler.(self, :update, previous_changes) }, on: :update
      after_commit -> { CustomActiveRecordObserver::Handler.(self, :destroy, previous_changes) }, on: :destroy
    end
  end
end
