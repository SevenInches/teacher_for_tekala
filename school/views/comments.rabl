node(:status) { 'success' }
node(:total) { @total }
child(@comments => :data){
  attributes :id, :content, :rate, :created_at
  child(:user){
		attribute :id, :name, :nickname, :mobile
  }
  child(:teacher){
		attribute :id, :name, :mobile, :rate
  }
  child(:order){
		attribute :id, :order_no
  }
}