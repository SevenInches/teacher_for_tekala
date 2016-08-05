node(:status) { 'success' }
child(@tweet => :data){
	attributes :id, :content, :photos, :created_at, :updated_at
	child(:user) {
		attribute :id, :name, :nickname, :mobile, :sex, :status_flag_word
	}
}
