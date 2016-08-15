node(:status) { 'success' }
node(:total) { @total }
child(@exams => :data){
  attributes :id, :date, :level_word, :result_word, :note
  child(:user){
    attributes :id, :name
    child(:product){  attributes :id, :name }
  }
}