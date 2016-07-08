node(:status) { 'success' }
child(@comment => :data){
	attributes :id, :user_id, :order_id, :teacher_id, :rate, :content, :created_at, :anonymous
	child(:user){
		attributes :id, :nickname, :mobile, :city, :sex, :avatar_url, :avatar_thumb_url
		node(:name)  { |val| val.is_vip == 1 ?  val.name + '(打包)' : val.name }
	}
	child(:photos => :photos){
	    attributes :id, :photo_thumb_url, :photo_url
	}

}
