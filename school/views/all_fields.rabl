node(:status) { 'success' }
node(:total) { @total }
child(@fields => :data){
  attributes :id, :name
}