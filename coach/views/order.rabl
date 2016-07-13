node(:status) { 'success' }
child(@order => :data){
  attributes :id, :order_no, :price, :amount, :promotion_amount, :discount, :teacher_id, :user_id, :device, :status, :status_word, :created_at, :book_time, :other_book_time, :has_coupon, :teacher_can_comment, :user_has_comment, :is_comment, :cancel_by_me, :type, :paid, :amount, :theme_word
    
  node(:quantity ) { |val| val.type == 1 ?  0 : val.quantity }
  attribute :pay_at,      :if => lambda { |val| !val.pay_at.nil? }
  attribute :done_at,     :if => lambda { |val| !val.done_at.nil? }
  attribute :cancel_at,   :if => lambda { |val| !val.cancel_at.nil? }
  attribute :note,        :if => lambda { |val| !val.note.nil? }
  attribute :subject,     :if => lambda { |val| !val.subject.nil? }
  child(:user){
    attributes :id, :name, :nickname, :mobile, :city, :sex, :score, :avatar_url, :avatar_thumb_url, :exam_type, :has_hour, :exam_type_word, :rate, :status_flag_word, :status_flag, :invite_code, :invite_url
  }
  child(:user_coupon => :coupon){
    attributes :id, :code, :money
  }

  child(:train_field => :train_field) {
    attributes :id, :name, :area_name, :address, :longitude, :latitude
  }

}

