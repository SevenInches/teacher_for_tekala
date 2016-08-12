node(:status) { 'success' }
node(:total) { @total }
child(@pays => :data){
  attributes :id, :pay_at, :amount, :explain
}