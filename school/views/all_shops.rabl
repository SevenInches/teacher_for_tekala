node(:status) { 'success' }
node(:total) { @total }
child(@shops => :data){
  attributes :id, :name
}