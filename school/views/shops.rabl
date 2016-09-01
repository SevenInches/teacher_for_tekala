node(:status) { 'success' }
node(:total) { @total }
child(@shops => :data) {
  attributes :id, :name, :address, :contact_phone, :profile, :logo,  :config, :rent_amount, :contact_user
  node(:student_count_today) { |val| @demo.present? ? '今天报名人数' : val.student_count_today }
  node(:student_count_month) { |val| @demo.present? ? '本月报名人数' : val.student_count_month }
}