[gem]: https://rubygems.org/gems/custom_active_record_observer

# CustomActiveRecordObserver

[![Gem Version](https://badge.fury.io/rb/custom_active_record_observer.svg)][gem]

A DSL to track create/update/destroy operations based on AR callbacks.

### Installation
Add the following code to your `Gemfile`

```ruby
# Gemfile
gem 'custom_active_record_observer'
```
and run `bundle install`

Then add the observation rules (in `config/initializers/events_observation.rb`)
```ruby
# config/initializers/events_observation.rb
CustomActiveRecordObserver.observe 'User' do
  on_create do |user|
    # do something
  end
end
```

In this expample we track model `User`. If a new user is created, AR `:after_commit` callback is launched and the block in `on_create` executes.

We can track by real classes (which is not always possible, since that code is better to be placed in `config/initializers`). But passing strings or symbols is also allowed:
```ruby
  CustomActiveRecordObserver.observe User, :EngagedUser, 'CompanyOwner' { ... }
```
Here we track three classes.

### Usage
How do we use `custom_active_record_observer` in the wild? For instance, in this example we publish `UserRegisteredEvent` on user creation. (using `rails_event_store` gem). This is a pretty useful trade-off if there are no operations or aggregates introduced in the system architecture.

```ruby
CustomActiveRecordObserver.observe 'User' do
  on_create do |user|
    Rails.application.config.event_store.publish_event(
      UserRegisteredEvent.strict(data: { user_id: user.id }),
      stream_name: "users-#{user.id}"
    )
  end
end
```

#### Usage with `handler`
`handler` might be passed into the observation. It is a simple object/class which has metho `call`. The result of `do..end` block is passed into that handler.

```ruby
handler = ->(event) do
  Rails.application.config.event_store.publish_event(
    event,
    stream_name: "users-#{ event.data.fetch(:user_id) }"
  )
end

CustomActiveRecordObserver.observe 'User', handler: handler do
  on_create do |user|
    UserRegisteredEvent.strict(data: { user_id: user.id })
  end

  on_add :user_group_id do |user|
    UserAssignedToUserGroup.strict(data: {
      user_id: user.id,
      user_group_id: user.user_group_id
    })
  end

  on_change :user_group_id do |user|
    UserAssignedToAnotherUserGroupEvent.strict(data: {
      user_id: user.id,
      user_group_id: user.user_group_id
    })
  end

  on_remove :user_group_id do |user|
    UserUnassignedFromUserGroupEvent.strict(data: {
      user_id: user.id,
      user_group_id: user.previous_changes.fetch(:user_group_id).first
    })
  end

  on_destroy do |user|
    UserTerminatedEvent.strict(data: { user_id: user.id })
  end
end
```

### Licence
See `LICENSE` file.

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/virtuozzo/custom_active_record_observer.
