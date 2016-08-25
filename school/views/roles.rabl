node(:status) { 'success' }
node(:total) { @total }
child(@roles => :data){
  attributes :id, :name, :cate_word
}