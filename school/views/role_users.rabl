node(:status) { 'success' }
node(:total) { @total }
child(@users => :data){
  attributes :id, :name
}