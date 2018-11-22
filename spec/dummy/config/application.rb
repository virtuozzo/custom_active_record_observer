require File.expand_path('boot', __dir__)

require 'active_record/railtie'

Bundler.require(*Rails.groups)
require 'custom_active_record_observer'

module Dummy
  class Application < Rails::Application
    config.encoding = 'utf-8'
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    config.eager_load = false
  end
end
