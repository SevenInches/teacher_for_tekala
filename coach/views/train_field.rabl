node(:status) { 'success' }
child(@train_field => :data){
	attributes :id, :name, :address, :longitude, :latitude, :area, :teacher_count, :area_name
	attribute :distance,     :if => lambda { |val| !val.distance.nil? }
	
}