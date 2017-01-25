
module DummyHandler
  CREATED = :created
  ADDED   = :added
  REMOVED = :removed
  CHANGED = :changed
  DELETED = :deleted

  def self.call(action); end
end

CustomActiveRecordObserver.observe :DummyModel, handler: DummyHandler do
  create           { DummyHandler::CREATED }
  on_add(:name)    { DummyHandler::ADDED }
  on_remove(:name) { DummyHandler::REMOVED }
  on_change(:name) { DummyHandler::CHANGED }
  destroy          { DummyHandler::DELETED }
end
