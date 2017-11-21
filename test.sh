#!/bin/bash

echo "*** Running custom_active_record_observer specs"

bundle install                                      || exit 1
bundle exec rake app:db:drop app:db:create          || exit 1
bundle exec rake app:db:migrate app:db:test:prepare || exit 1
bundle exec rspec spec
