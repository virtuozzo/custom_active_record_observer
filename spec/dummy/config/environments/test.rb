Dummy::Application.configure do
  config.cache_classes = true
  config.serve_static_files = true
  config.static_cache_control = 'public, max-age=3600'
  config.whiny_nils = true
  config.active_support.deprecation = :stderr
end
