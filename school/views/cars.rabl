node(:status) { 'success' }
node(:total) { @total }
child(@cars => :data){
  attributes :id, :produce_year, :note, :name, :exam_type, :open
  node(:number ) { |val| @demo.present? ? '车牌号' : val.number }
  node(:brand ) { |val| @demo.present? ? '品牌' : val.brand }
  child(:branch) {  attributes :id, :name  }
}