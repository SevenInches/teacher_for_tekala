node(:status) { 'success' }
child(@tweet => :data){
	attributes :id, :content, :photos, :comment_count, :like_count, :photo_count, :created_at, :updated_at
	child(:user) {
		attribute :id, :name, :nickname, :mobile,  :avatar_url, :avatar_thumb_url
	}
}
