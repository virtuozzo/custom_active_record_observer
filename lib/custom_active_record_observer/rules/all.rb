require_relative 'base_rule'

Dir[File.expand_path('*.rb', __dir__)].each { |f| require f }
