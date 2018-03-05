require 'active_support/dependencies'

module CustomActiveRecordObserver
  require_relative 'custom_active_record_observer/all'

  mattr_accessor :schema
  @@schema = Schema.new

  # @param class_names [Symbols] - list of class names
  #   may be an object of Class, Symbol, or String
  #   (e.g. :User, 'User' or User)
  # @example Usage without handler
  #   CustomActiveRecordObserver.observe 'User' do
  #     on_create do |user|
  #       Rails.application.config.event_store.publish_event(
  #         UserRegisteredEvent.strict(data: { user_id: user.id }),
  #         stream_name: "users-#{user.id}"
  #       )
  #     end
  #
  #     on_destroy do |user|
  #       Rails.application.config.event_store.publish_event(
  #         UserTerminatedEvent.strict(data: { user_id: user.id }),
  #         stream_name: "users-#{user.id}"
  #       )
  #     end
  #   end
  #
  # @example Usage with handler
  #   handler = ->(event) {
  #     Rails.application.config.event_store.publish_event(
  #       event,
  #       stream_name: "users-#{event.data[:user_id]}"
  #     )
  #   }
  #   CustomActiveRecordObserver.observe 'User', handler: handler do
  #     on_create do |user|
  #       UserRegisteredEvent.strict(data: { user_id: user.id })
  #     end
  #
  #     on_destroy do |user|
  #       UserTerminatedEvent.strict(data: { user_id: user.id })
  #     end
  #   end
  def self.observe(*class_names, handler: proc {}, &block)
    class_names.each do |class_name|
      DSL.new(block).actions_and_rules.each do |(action, rule)|
        schema.add_rule(class_name, action, rule, handler)
      end
    end
  end
end
