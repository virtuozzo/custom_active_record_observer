module CustomActiveRecordObserver
  module Observable
    extend ActiveSupport::Concern

    included do
      if defined?(CollectiveIdea::Acts::NestedSet) && self < CollectiveIdea::Acts::NestedSet::Model
        prepend CustomActiveRecordObserver::ChangesTracker[:set_depth!]
      end

      if try(:paranoid?)
        include Paranoid
      else
        include Base
      end
    end
  end
end
