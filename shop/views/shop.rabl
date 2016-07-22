node(:status) { 'success' }
child(@shop => :data){
      attributes :id, :name, :address, :contact_phone, :logo
}