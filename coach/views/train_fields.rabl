node(:status) { 'success' }
node(:total) { @total }
child(@train_fields => :data){
	attributes :id, :name, :address, :longitude, :latitude, :area, :teacher_count, :area_name
	attribute :distance,     :if => lambda { |val| !val.distance.nil? }
	
}