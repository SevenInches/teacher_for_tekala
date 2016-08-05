node(:status) { 'success' }
node(:total) { @total }
child(@cars => :data){
  attributes :id, :produce_year, :note, :name, :open
  node(:number) { |val| @demo.present? ? '车牌号' : val.number }
  node(:brand) { |val| @demo.present? ? '品牌' : val.brand }
  node(:exam_type) { |val| @demo.present? ? val.exam_type_demo : val.exam_type }
  child(:branch) {  attributes :id, :name  }
  child(:train_field) {  attributes :id, :name  }
}