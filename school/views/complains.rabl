node(:status) { 'success' }
node(:total) { @total }
child(@complains => :data){
  attributes :id, :content
  node(:created_at ) { |val| val.created_at.strftime("%Y-%m-%d %H:%M") if val.created_at.present? }
  child(:user){
		attribute :id, :name, :nickname, :mobile
  }
}