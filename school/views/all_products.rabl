node(:status) { 'success' }
node(:total) { @total }
child(@products => :data){
  attributes :id, :name
}