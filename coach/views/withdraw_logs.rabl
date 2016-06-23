node(:status) { 'success' }
node(:total) { @total }
child(@logs => :data){
  attributes :id, :amounts, :status, :note, :created_at
}