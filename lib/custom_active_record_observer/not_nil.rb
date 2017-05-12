module CustomActiveRecordObserver
  module NotNil
    def self.===(other)
      super || !other.nil?
    end
  end
end
