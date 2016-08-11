node(:status) { 'success' }
node(:total) { @total }
child(@tweets => :data){
  attributes :id, :content, :comment_count, :photos, :created_at, :updated_at
  child(:user){
		attribute :id, :name, :nickname, :mobile,  :avatar_url, :avatar_thumb_url
  }
}