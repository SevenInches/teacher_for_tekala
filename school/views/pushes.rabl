node(:status) { 'success' }
node(:total) { @total }
child(@pushes => :data){
  attributes :id, :message, :value, :version, :user_status
  child(:channel){  attributes :id, :name  }
  node(:editions) { |val| @demo.present? ? val.editions_demo : val.editions}
  node(:type) { |val| @demo.present? ? val.type_demo : val.type}
}