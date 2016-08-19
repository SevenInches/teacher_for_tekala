node(:status) { 'success' }
node(:total) { @total }
child(@teachers => :data){
	attributes :id, :rate, :name, :profile, :avatar_thumb_url, :avatar_url, :has_hour, :mobile
	attributes :hometown,   :if => lambda { |val| !val.hometown.nil? }
	node(:success_users ) { |val| @demo.present? ? '通过学员数' : val.success_users }
	node(:exam_type ) { |val| @demo.present? ? val.exam_type_demo : val.exam_type }
	node(:tech_type ) { |val| @demo.present? ? val.tech_type_demo : val.tech_type }
	node(:sex ) { |val| @demo.present? ? val.sex_demo : val.sex }
	child(:branch => :branch){attributes :id, :name }
	child(:train_fields){ attributes :id, :name }
	child(:car){ attributes :id, :number, :brand }
	attributes :bank_name, :bank_card, :wechart
}
