node(:status) { 'success' }
node(:total) { @total }
child(@notices => :data){
  attributes :id, :type, :order_id, :value, :note
}
