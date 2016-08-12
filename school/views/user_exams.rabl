node(:status) { 'success' }
node(:total) { @total }
child(@exams => :data){
  attributes :id, :date, :note, :result_word, :level_word
}