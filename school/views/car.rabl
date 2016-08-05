node(:status) { 'success' }
child(@car => :data){
  attributes :id, :produce_year, :note, :exam_type
  node(:number ) { |val| @demo.present? ? '车牌号' : val.number}
  node(:brand ) { |val| @demo.present? ? '品牌' : val.brand}
  child(:train_field) {  attributes :id, :name  }
  child(:branch) {  attributes :id, :name  }
  child(:check) {
    node(:check_end ) { |val| @demo.present? ? '检验截止日期' : val.check_end.strftime("%Y:%m:%d")}
    node(:year_check_end ) { |val| @demo.present? ? '年检截止日期' : val.year_check_end.strftime("%Y:%m:%d")}
    node(:season_check_end ) { |val| @demo.present? ? '季审评定截止日期' : val.season_check_end.strftime("%Y:%m:%d")}
    node(:second_check_end ) { |val| @demo.present? ? '二级维护截止日期' : val.second_check_end.strftime("%Y:%m:%d")}
  }
}