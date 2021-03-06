node(:status) { 'success' }
node(:total) { @total }
child(@orders => :data){
  attributes :id, :order_no,:train_field_name, :user_id, :status, :status_word, :quantity, :is_comment, :cancel_by_me, :accept_status, :created_at, :paid, :amount, :theme_word
  node(:book_time ) { |val| val.book_time.strftime('%FT%T.%L%:z') if val.book_time.present?  }
  attribute :pay_at,      :if => lambda { |val| !val.pay_at.nil? }
  attribute :done_at,     :if => lambda { |val| !val.done_at.nil? }
  child(:user){
    attributes :id, :name, :nickname, :mobile, :sex_format, :rate, :avatar_url, :avatar_thumb_url, :exam_type, :status_flag
    node(:status_flag_word ) { |user| user.status_flag_word }
    node(:exam_type_word) { |user| user.exam_type_word }
  }
  child(:train_field => :train_field) {
    attributes :id, :name, :area_name, :address, :longitude, :latitude
  }
}
