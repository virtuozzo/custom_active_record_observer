# @title CustomActiveRecordObserver::NotNil
module CustomActiveRecordObserver
  # A module to represent any of values that are not equal to +nil+
  module NotNil
    # @param other [Any]
    # @return [Boolean]
    def self.===(other)
      super || !other.nil?
    end
  end
end
