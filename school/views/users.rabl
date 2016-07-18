node(:status) { 'success' }
node(:total) { @total }
child(@users => :data){
	attributes :id, :name, :nickname, :mobile, :city_name, :sex, :score, :avatar_url, :avatar_thumb_url, :motto, :type, :type_word, :status_flag_word, :status_flag, :exam_type, :exam_type_word, :has_hour, :login_count, :has_assign, :address
	attributes :birthday,    :if => lambda { |val| !val.birthday.nil? }
	attributes :started_at,  :if => lambda { |val| !val.started_at.nil? }
	attributes :last_login,  :if => lambda { |val| !val.last_login.nil? }
}

