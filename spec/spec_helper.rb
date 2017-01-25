ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('dummy/config/environment', __dir__)

require 'rspec'
require 'pry'
require 'custom_active_record_observer'
require 'rake'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
  config.profile_examples = nil
  config.order = :random
  config.expose_dsl_globally = true
end
