node(:status) { 'success' }
node(:total) { @total }
child(@cars => :data){
  attributes :id, :produce_year, :note, :name, :open
  node(:number) { |val| @demo.present? ? '车牌号' : val.number }
  node(:brand) { |val| @demo.present? ? '品牌' : val.brand }
  node(:handle_status) { |val| @demo.present? ? val.check.handle_status_demo : val.check.handle_status if val.check.present? }
  node(:exam_type) { |val| @demo.present? ? val.exam_type_demo : val.exam_type }
  child(:branch) {  attributes :id, :name  }
  child(:train_field) {  attributes :id, :name }
  child(:check) {
    node(:check_end ) { |val| @demo.present? ? '检验截止日期' : val.check_end.strftime("%Y:%m:%d")}
    node(:year_check_end ) { |val| @demo.present? ? '年检截止日期' : val.year_check_end.strftime("%Y:%m:%d")}
    node(:season_check_end ) { |val| @demo.present? ? '季审评定截止日期' : val.season_check_end.strftime("%Y:%m:%d")}
    node(:second_check_end ) { |val| @demo.present? ? '二级维护截止日期' : val.second_check_end.strftime("%Y:%m:%d")}
  }
}