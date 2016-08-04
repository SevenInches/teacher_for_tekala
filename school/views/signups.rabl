node(:status) { 'success' }
node(:total) { @total }
child(@users){
  attributes :id, :name, :mobile, :sex, :id_card, :address, :manager_no, :operation_no, :apply_type, :exam_type
  node(:origin ) { |val| @demo.present? ? val.origin_demo : val.origin}
  node(:local ) { |val| @demo.present? ? val.local_demo : val.local}
  child(:product => :product) {
    attributes :id, :name
  }
  child(:branch => :branch) {
    attributes :id, :name
  }
  child(:signup => :signup) {
    attributes :id, :order_no, :amount, :status
  }
}