node(:status) { 'success' }
child(@comment => :data){
  attributes :id, :content, :rate, :created_at
  child(:user){
		attribute :id, :name, :nickname, :mobile
  }
  child(:teacher){
		attribute :id, :name, :mobile
  }
  child(:order){
		attribute :id, :order_no
  }
}