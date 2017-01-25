$:.push File.expand_path('lib', __dir__)

require 'custom_active_record_observer/version'

Gem::Specification.new do |s|
  s.name    = 'custom_active_record_observer'
  s.version = CustomActiveRecordObserver::VERSION
  s.authors = ['OnApp devs']
  s.email   = ['onapp@onapp.com']
  s.summary = 'CustomActiveRecordObserver'

  s.files = Dir['{app,config,db,lib}/**/*'] + %w(Rakefile README.md)

  s.add_dependency 'activerecord', '>= 3.2', '< 6'
  s.add_dependency 'railties',     '>= 3.2', '< 6'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'pry'
end
