node(:status) { 'success' }
node(:total) { @total }
child(@orders => :data){
  attributes :id, :order_no,:train_field_name, :user_id, :status, :status_word, :book_time, :quantity, :teacher_can_comment, :user_has_comment, :is_comment, :cancel_by_me, :accept_status, :created_at, :paid, :amount, :theme_word

  node(:quantity )  { |val| val.type == 1 ?  0 : val.quantity }
  node(:book_time ) { |val| val.type == 1 ?  '' : val.book_time }
  attribute :pay_at,      :if => lambda { |val| !val.pay_at.nil? }
  attribute :done_at,     :if => lambda { |val| !val.done_at.nil? }

  child(:user){
    attributes :id, :nickname, :mobile, :city, :sex, :score, :avatar_url, :avatar_thumb_url, :exam_type, :has_hour, :exam_type_word, :rate, :status_flag_word, :status_flag, :invite_code, :invite_url
    node(:name )  { |val| val.is_vip == 1 ?  val.name + '(打包)' : val.name }
  }

  child(:train_field => :train_field) {
    attributes :id, :name, :area_word, :address, :longitude, :latitude
  }
}
