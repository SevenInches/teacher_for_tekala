node(:status) { 'success' }
node(:total) { @total }
child(@subparts => :data){
  attributes :id, :name, :route, :pic, :weight
}