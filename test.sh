#!/bin/bash

key=$1

echo "*** Running custom_active_record_observer specs"

if [ "$key" != '--skip-bundle' ]; then
  bundle install  || exit 1
fi

bundle exec appraisal install                       || exit 1
bundle exec rake app:db:drop app:db:create          || exit 1
bundle exec rake app:db:migrate app:db:test:prepare || exit 1

bundle exec rspec spec --exclude-pattern 'spec/appraisals/**/*_spec.rb' &&
  bundle exec appraisal paranoia rspec spec --exclude-pattern 'spec/appraisals/awesome_nested_set/**/*_spec.rb' &&
  bundle exec appraisal awesome_nested_set rspec spec --exclude-pattern 'spec/appraisals/paranoia/**/*_spec.rb'
