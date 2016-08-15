node(:status) { 'success' }
node(:total) { @total }
child(@users => :data){
	attributes :id, :name, :nickname, :mobile, :city_name, :sex, :avatar_url, :avatar_thumb_url, :motto, :has_hour, :login_count, :has_assign, :address
	attributes :status_flag, :status_flag_word, :exam_type, :exam_type_word, :started_at, :last_login_at
	node(:type ) { |val| @demo.present? ? val.type_demo : val.type}
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
}

