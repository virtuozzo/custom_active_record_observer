module CustomActiveRecordObserver
  module Observable
    extend ActiveSupport::Concern

    included do
      after_commit -> { CustomActiveRecordObserver.handle(self, :create, previous_changes) }, on: :create
      after_commit -> { CustomActiveRecordObserver.handle(self, :update, previous_changes) }, on: :update
      after_commit -> { CustomActiveRecordObserver.handle(self, :destroy, previous_changes) }, on: :destroy
    end
  end
end
