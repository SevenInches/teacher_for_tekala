node(:status) { 'success' }
node(:total) { @total }
child(@fields => :data){
	attributes :id, :name, :address, :longitude, :latitude, :area_name, :good_tags, :bad_tags, :area_word, :subject, :subject_word
	attribute :distance,     :if => lambda { |val| !val.distance.nil? }
	attribute :teacher_num
}
