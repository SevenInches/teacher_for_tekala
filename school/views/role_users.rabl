node(:status) { 'success' }
node(:total) { @total }
child(@users => :data){
  attributes :id, :name, :mobile
  node(:last_login_at ) { |val|  val.last_login_at.strftime('%Y-%m-%d %H:%M') if val.last_login_at.present?}
}