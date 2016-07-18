node(:status) { 'success' }
child(@school => :data){
      attributes :id, :city_name, :name, :address, :contact_phone, :profile, :is_vip, :master,:logo, :found_at, :latitude, :longitude
      node(:user_num ) { |val| val.user_num ? val.user_num : 0  }
      node(:signup_amount ) { |val| val.signup_amount ? val.signup_amount : 0  }
}