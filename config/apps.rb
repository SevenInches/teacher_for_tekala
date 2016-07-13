# -*- encoding : utf-8 -*-

Padrino.configure_apps do
  # enable :sessions
  set :session_secret, 'dc64dc47533f13c901d7ab39ca7830716190432afce22fd4f577cda502c9427d'
  set :protection, false
  set :protect_from_csrf, false
  set :allow_disabled_csrf, true
end

Rabl.configure do |config|
  config.include_json_root  = false
  config.include_child_root = false
end


CarrierWave.configure do |config|
  config.root = PADRINO_ROOT+'/public'
end

# Mounts the core application for this project

Padrino.mount('Tekala::Coach',   	  :app_file => Padrino.root('coach/app.rb')).to('/')


