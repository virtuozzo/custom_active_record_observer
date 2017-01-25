module CustomActiveRecordObserver
  module Observable
    extend ActiveSupport::Concern

    included do
      after_create  { CustomActiveRecordObserver.handle(self, :create,  changes) }
      after_update  { CustomActiveRecordObserver.handle(self, :update,  changes) }
      after_destroy { CustomActiveRecordObserver.handle(self, :destroy, changes) }
    end
  end
end
