node(:status) { 'success' }
child(@shop => :data) {
  attributes :id, :name, :address, :contact_phone, :contact_user, :profile, :logo,  :config, :longtitude, :latitude
  }