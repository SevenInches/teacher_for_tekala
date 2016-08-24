node(:status) { 'success' }
node(:total) { @total }
child(@cars => :data){
  attributes :id, :number, :brand, :exam_type
}