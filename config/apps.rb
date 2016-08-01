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

Padrino.mount('Tekala::School',   	  :app_file => Padrino.root('school/app.rb')).to('/school')
Padrino.mount('Tekala::Shop',   	  :app_file => Padrino.root('shop/app.rb')).to('/shop')
Padrino.mount('Tekala::TestForSchool',   	  :app_file => Padrino.root('test_for_school/app.rb')).to('/test_for_school')
Padrino.mount('Tekala::TestForTeacher',   	  :app_file => Padrino.root('test_for_teacher/app.rb')).to('/test_for_teacher')
Padrino.mount('Tekala::TestForShop',   	  :app_file => Padrino.root('test_for_shop/app.rb')).to('/test_for_shop')
Padrino.mount('Tekala::Coach',   	  :app_file => Padrino.root('coach/app.rb')).to('/')

