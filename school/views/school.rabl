node(:status) { 'success' }
child(@school => :data){
      attributes :id, :city_name, :name, :address, :contact_phone, :profile, :is_vip, :master, :logo, :found_at, :latitude, :longitude
      node(:user_num) { |val| @demo.present? ? val.user_num_demo : val.user_num }
      node(:signup_amount) { |val| @demo.present? ?val.signup_amount_demo : val.signup_amount  }
}