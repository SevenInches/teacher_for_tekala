node(:status) { 'success' }
node(:total) { @total }
child(@ads => :data){
  attributes :id, :title, :image_url, :value

}
