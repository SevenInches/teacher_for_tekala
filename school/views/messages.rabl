node(:status) { 'success' }
node(:total) { @total }
child(@messages => :data) {
  attributes :id, :content, :date, :type, :type_word, :url
}