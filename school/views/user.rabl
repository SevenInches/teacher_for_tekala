node(:status) { 'success' }
child(@user => :data){
  attributes :id, :name, :mobile, :id_card, :city_name, :sex, :avatar_url, :avatar_thumb_url, :motto, :login_count, :has_assign,:has_hour, :address, :signup_at
  attributes :last_login_at,  :last_book_at, :status_flag, :status_flag_word, :exam_type, :exam_type_word
  child(:product) {
		attributes :id, :name
  }
  child(:shop) {
		attributes :id, :name
  }
  child(:branch) {
		attributes :id, :name
  }
  child(:user_plan){
		attributes :exam_two, :exam_three
  }
  child(:user_exam){
		attributes :exam_one, :exam_four
  }
}