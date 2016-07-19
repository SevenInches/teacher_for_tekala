node(:status) { 'success' }
node(:total) { @total }
child(@teachers => :data){

	 attributes :id, :rate, :name, :profile, :avatar_thumb_url, :avatar_url, :exam_type, :tech_type, :exam_type_word, :mobile
	 attributes :remark,     :if => lambda { |val| !val.remark.nil? }
     attributes :sex,        :if => lambda { |val| !val.sex.nil? }
	 attributes :price,      :if => lambda { |val| !val.price.nil?  }
	 attributes :promo_price,  :if => lambda { |val| !val.promo_price.nil? }
	 attributes :hometown,   :if => lambda { |val| !val.hometown.nil? }
	 attributes :skill,      :if => lambda { |val| !val.skill.nil? }
	 attributes :address,  :if => lambda { |val| !val.address.nil? }
}
