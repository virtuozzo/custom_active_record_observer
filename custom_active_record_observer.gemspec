$:.push File.expand_path('lib', __dir__)

require 'custom_active_record_observer/version'

Gem::Specification.new do |s|
  s.name = 'custom_active_record_observer'
  s.version = CustomActiveRecordObserver::VERSION
  s.author = 'OnApp Ltd.'
  s.email = 'support@onapp.com'
  s.homepage = 'https://github.com/OnApp/custom_active_record_observer'
  s.summary = 'A small handy library to track create/update/destroy actions on active_record models'
  s.license = 'Apache 2.0'
  s.files = Dir['lib/**/*'] + %w(Rakefile README.md LICENSE)
  s.required_ruby_version = '>= 2.2.0'
  s.has_rdoc = 'yard'

  s.description = <<-EOF
    This gem delivers a simple DSL based on the after_commit callback
    which can be used as an alternative to hooks from inside the model
  EOF

  s.add_dependency 'activerecord', '>= 3.2', '< 6'
  s.add_dependency 'railties',     '>= 3.2', '< 6'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'pry'
end
