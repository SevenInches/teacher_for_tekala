node(:status) { 'success' }
node(:total) { @total }
child(@tweets => :data){
  attributes :id, :content, :city_word, :photos, :created_at
  child(:user){
		attribute :id, :name, :nickname, :mobile
  }
}