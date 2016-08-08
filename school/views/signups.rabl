node(:status) { 'success' }
node(:total) { @total }
child(@data){
  attributes :id, :name, :mobile, :sex, :id_card, :address, :manager_no, :operation_no
  node(:origin ) { |val| @demo.present? ? val.origin_demo : val.origin}
  node(:local ) { |val| @demo.present? ? val.local_demo : val.local}
  node(:apply_type ) { |val| @demo.present? ? val.apply_type_demo : val.apply_type}
  node(:pay_type ) { |val| @demo.present? ? val.pay_type_demo : val.pay_type}
  node(:exam_type ) { |val| @demo.present? ? val.exam_type_demo : val.exam_type}
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