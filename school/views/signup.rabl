node(:status) { 'success' }
child(@data){
  attributes :id, :name, :mobile, :sex, :id_card, :address, :manager_no, :operation_no, :exam_type
  node(:origin ) { |val| @demo.present? ? val.origin_demo : val.origin}
  node(:local ) { |val| @demo.present? ? val.local_demo : val.local}
  node(:apply_type ) { |val| @demo.present? ? val.apply_type_demo : val.apply_type}
  node(:pay_type ) { |val| @demo.present? ? val.pay_type_demo : val.pay_type}
  child(:branch => :branch) {
    attributes :id, :name
  }
  child(:signup) {
    attributes :id, :order_no, :amount, :status
    child(:product => :product) {
      attributes :id, :name
    }
  }
}