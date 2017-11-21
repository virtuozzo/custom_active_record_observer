# CustomActiveRecordObserver

`custom_active_record_observer` is a DSL to track create/update/destroy operations based on AR callbacks.

This is just a DSL like:

```
CustomActiveRecordObserver.observe :EngagedUser, :CompanyOwner, handler: CustomerEventPublisher.new do
  on_create do |customer|
    Events::CustomerSignedUp.new(data: {customer_id: customer.id}
  end

  on_destroy do |customer|
    Events::CustomerSignedOut.new(data: {…})
  end

  on_change :group_id do |customer|
    Events::CustomerGroupChanged.new(data: {…})
  end
…
end
```

which can be put into a single initializer file instead of scattering around and having it in each AR model.
That file is easier to remove in future. It incapsulates all the “inaccurate" dependencies.
