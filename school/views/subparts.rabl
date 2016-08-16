node(:status) { 'success' }
child(@subparts => :data){
  attributes :id, :name, :route, :pic, :weight
  node(:config) { |val| @demo.present? ? val.config_demo : val.config}
}