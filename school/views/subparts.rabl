node(:status) { 'success' }
node(:total) { @total }
child(@subparts => :data){
  attributes :id, :name, :route, :pic, :weight
  node(:config) { |val| @demo.present? ? val.config_demo : val.config}
}