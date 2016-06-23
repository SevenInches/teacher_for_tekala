node(:status) { 'success' }
node(:total) { @total }
child(@train_fields => :data){
	attributes :id, :name, :address, :longitude, :latitude, :area, :teacher_count
	attribute :distance,     :if => lambda { |val| !val.distance.nil? }
	
	node(:area_word) { |val| TrainField::area_word val.area }
	
}