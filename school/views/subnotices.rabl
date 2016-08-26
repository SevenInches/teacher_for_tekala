node(:status) { 'success' }
child(@notices => :data){
  attributes :id, :name, :count
}
child(:total_count) { @total }