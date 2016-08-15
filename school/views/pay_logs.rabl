node(:status) { 'success' }
node(:total) { @total }
child(@logs => :data){
  attributes :id, :pay_date, :amounts
}