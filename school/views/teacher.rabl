node(:status) { 'success' }
node(:total) { @total }
child(@teacher => :data){
  attributes :id, :rate, :name, :profile, :avatar_thumb_url, :avatar_url, :has_hour, :mobile
  attributes :remark,     :if => lambda { |val| !val.remark.nil? }
  attributes :hometown,   :if => lambda { |val| !val.hometown.nil? }
  attributes :address,  :if => lambda { |val| !val.address.nil? }
  node(:user_success ) { |val| @demo.present? ? '通过学员数' : val.user_success }
  node(:exam_type ) { |val| @demo.present? ? val.exam_type_demo : val.exam_type }
  node(:tech_type ) { |val| @demo.present? ? val.tech_type_demo : val.tech_type }
  node(:sex ) { |val| @demo.present? ? val.sex_demo : val.sex }
}