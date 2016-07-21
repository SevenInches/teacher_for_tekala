node(:status) { 'success' }
node(:total) { @total }
child(@students => :data){
	attributes :id, :name, :mobile, :sex
}