node(:status) { 'success' }
child(@teacher => :data){
	attributes :id, :id_card, :rate, :name, :profile, :wechat, :driving_age, :teaching_age, :avatar_thumb_url
	attributes :avatar_url, :status, :status_flag, :exam_type,  :exam_type_word, :tech_type, :tech_type_word
    attributes :mobile, :waiting_count, :bank_card, :bank_name, :bank_account_name, :first_order_date, :pay_type, :vip, :city
	  attributes :remark,     :if => lambda { |val| !val.remark.nil? }
	  attributes :email,      :if => lambda { |val| !val.email.nil? }
	  attributes :age,    :if => lambda { |val| !val.age.nil? }
	  attributes :sex,    :if => lambda { |val| !val.sex.nil? }
	  attributes :qq,       :if => lambda { |val| !val.qq.nil? }
	  attributes :price,  :if => lambda { |val| !val.price.nil? }
	  attributes :promo_price,  :if => lambda { |val| !val.promo_price.nil? }
	  attributes :address,  :if => lambda { |val| !val.address.nil? }
	  attributes :training_field,    :if => lambda { |val| !val.training_field.nil? }
	  attributes :training_address,  :if => lambda { |val| !val.training_address.nil? }
	  node(:has_hour ) { |teacher| teacher.has_hour ? teacher.has_hour : 0  }
	  node(:comment_count ) { |teacher| teacher.comments ? teacher.comments.count : 0  }
	  child(:my_train_field => :my_train_field){
	  	attributes :id, :name, :address, :longitude, :latitude
	  }
      child(:school){
       	attributes :id, :city_name, :name, :address, :phone, :profile, :is_vip, :master,:logo, :found_at
      }
}
