node(:status) { 'success' }
node(:total) { @total }
child(@branches => :data){
  attributes :id, :name
}