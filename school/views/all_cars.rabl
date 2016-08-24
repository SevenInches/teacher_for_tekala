node(:status) { 'success' }
node(:total) { @total }
child(@cars => :data){
  attributes :id
  node(:name) { |val| val.number }
}