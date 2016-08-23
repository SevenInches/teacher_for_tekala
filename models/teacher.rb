class Teacher
  include DataMapper::Resource

  attr_accessor :password, :teaching_age, :driving_age, :qiniu_avatar, :device
  
  C1 = [1,3]
  C2 = [2,3]
  C2ADD = 20
  # property <name>, <type>
  property :id, Serial
  property :crypted_password, String, :length => 70

  property :name, String, :required => true,
           :messages => {:presence => '请填写姓名'}
  property :age, Integer
  property :sex, Integer, :default => 1#性别 1男 0女
  # property :id_card, String, :unique => true, :required => true,
  #          :messages => {:is_unique => "身份证号码已经存在", 
  #                        :presence => '请填写身份证号码'}
  # property :drive_card, String, :unique => true, :required => true,
  #          :messages => {:is_unique => "驾驶证号码已经存在",
  #                        :presence => '请填写驾驶证号码'}
  # property :teach_card, String, :unique => true,
  #          :messages => {:is_unique => "教师证号码已经存在",
  #                        :presence => '请填写教师证号码'}
  property :id_card, String
  property :drive_card, String
  property :teach_card, String
  property :bank_card, String, :default => ''
  
  property :start_drive, DateTime
  property :start_teach, DateTime
  property :skill, String
  property :profile, Text, :lazy => false, :default => ''
  property :hometown, String
  property :avatar, String, :auto_validation => false
  property :id_card_photo, String, :auto_validation => false
  property :id_card_back_photo, String, :auto_validation => false
  property :drive_card_photo, String, :auto_validation => false
  property :car_lincese_photo, String, :auto_validation => false #车牌照
  property :livecard_front_photo, String, :auto_validation => false
  property :livecard_back_photo, String, :auto_validation => false
  property :lincese_front_photo, String, :auto_validation => false
  property :lincese_back_photo, String, :auto_validation => false
  property :bank_card_photo, String, :auto_validation => false

  property :tech_hours, Integer, :default => 0
  property :earn_money, Integer, :default => 0
  
  # 结算类型，默认是按天结算，合作久的教练改为按周结算
  property :pay_type, String, :default => 'day'

  #银行卡支行名称
  property :bank_name, String, :default => ''

  #银行卡持卡人姓名
  property :bank_account_name, String, :default => ''

  #'未知'=>1, 'C1'=>2, 'C2'=>3, 'C1/C2'=>4
  property :exam_type, Integer, :default => 1 #教练教学的车型

  # '科目二/科目三 => 1', '科目二 => 2'，'科目三 => 3'
  property :tech_type, Integer, :default => 1 #教练教学的类型

  property :mobile, String, :unique => true, :required => true,
           :messages => {:is_unique => "手机号已经存在",
                          :presence => '请填写联系电话'}
  property :wechat, String, :default => ''
  property :email,  String, :default => ''
  property :address, String, :default => ''
  property :remark,  String, :default => ''

  property :referee, String, :default => ''

  property :price, Integer, :default => 119, :min => 0
  property :promo_price, Integer, :default => 119, :min => 0
  property :created_at, DateTime
  property :qq, String, :default => ''

  #教练排名
  property :sort, Integer,:default => 0

  #教练状态 0休假 1正常使用
  property :status_flag , Integer, :default => 1
  
  #'待审核'=>1, '审核通过'=>2, '审核不通过'=>3, '报名' => 4
  property :status, Integer, :default => 1

  property :map, String, :auto_validation => false

  property :date_setting, String, :default => ''

  property :city_id, Integer

  #教练权重
  property :weight, Integer, :default => 0
  
  property :open, Integer, :default => 1

  property :login_count, Integer, :default => 0

  property :vip, Integer, :default => 0#收入是否已超3万元

  property :school_id, Integer

  property :branch_id, Integer

  #通过学员数
  property :success_users, Integer, :default => 0

  has n, :comments, :model => 'TeacherComment', :child_key =>'teacher_id' , :constraint => :destroy

  has n, :orders

  has n, :train_fields, 'TrainField', :through => :teacher_field, :via => :train_field

  has 1, :teacher_audit, 'TeacherAudit', :child_key => 'teacher_id', :constraint => :destroy

  has 1, :car, 'Car', :child_key => 'teacher_id', :constraint => :destroy

  #教练接单
  has n, :order_confirms, :model => 'OrderConfirm', :child_key => 'teacher_id', :constraint => :destroy

  # 教练钱包
  #has 1, :teacher_wallet, :constraint => :destroy
  has n, :users

  has n, :pay_logs, :model => 'TeacherPayLog', :child_key => 'teacher_id'

  belongs_to :school

  belongs_to :branch

  belongs_to :city

  def city_name
    city.name
  end
  
  mount_uploader :drive_card_photo, DrivePhoto

  mount_uploader :teach_card_photo, TeachPhoto

  mount_uploader :avatar, TeacherAvatar

  mount_uploader :id_card_photo, IdCardPhoto

  mount_uploader :id_card_back_photo, IdCardPhoto

  mount_uploader :car_lincese_photo, CarPhoto

  mount_uploader :livecard_front_photo, LiveCardPhoto

  mount_uploader :livecard_back_photo, LiveCardPhoto

  mount_uploader :lincese_front_photo, TeachPhoto #教练证正面

  mount_uploader :lincese_back_photo, TeachPhoto #教练证反面

  mount_uploader :bank_card_photo, BankPhoto

  mount_uploader :map, MapPhoto

  after :create, :push_manager

  # Callbacks
  before :save, :encrypt_password

  def push_manager
    #创建教练验证
    TeacherAudit.create(:teacher_id => id)
  end

  def rate 
    return 5.0  if comments.size < 1
    score = 0.0
    comments.each do |comment|
      score = score + comment.rate.to_f 
    end
    return (score/comments.size).to_f
    #减少一次mysql 查询
    # comments.avg(:rate).round(1)
  end

  def week_money
     orders.all(:status => Order::pay_or_done, :created_at => ((Date.today-6.day)..(Date.today+1.day)) ).sum(:quantity).to_i * price
  end

  def all_money
    sum = orders.all(:status => Order::pay_or_done).sum(:quantity)
    if sum.present?
      price.present? ? sum.to_i * price : 0
    end
  end

  def has_hour
    tech_hours.to_i if tech_hours.present?
  end

  def avatar_thumb_url
     avatar.thumb && avatar.thumb.url ? CustomConfig::HOST + avatar.thumb.url : CustomConfig::HOST + '/m/images/default_teacher_avatar.png' 

  end 

  def avatar_url
     avatar && avatar.url ? CustomConfig::HOST + avatar.url : CustomConfig::HOST + '/m/images/teacher_default_photo.png' 
  end

  def id_card_thumb_url
     id_card_photo.thumb && id_card_photo.thumb.url ? CustomConfig::HOST + id_card_photo.thumb.url : CustomConfig::HOST + '/images/icon180.png'
  end 

  def id_card_url
     id_card_photo && id_card_photo.url ? CustomConfig::HOST + id_card_photo.url : ''
  end

  def id_card_back_thumb_url
     id_card_back_photo.thumb && id_card_back_photo.thumb.url ? CustomConfig::HOST + id_card_back_photo.thumb.url : ''
  end 

  def id_card_back_url
     id_card_back_photo && id_card_back_photo.url ? CustomConfig::HOST + id_card_back_photo.url : ''
  end

  def teach_thumb_url
     teach_card_photo.thumb && teach_card_photo.thumb.url ? CustomConfig::HOST + teach_card_photo.thumb.url : ''
  end 

  def teach_url
     teach_card_photo && teach_card_photo.url ? CustomConfig::HOST + teach_card_photo.url : ''
  end

  def drive_thumb_url
     drive_card_photo.thumb && drive_card_photo.thumb.url ? CustomConfig::HOST + drive_card_photo.thumb.url : ''
  end 

  def drive_url
     drive_card_photo && drive_card_photo.url ? CustomConfig::HOST + drive_card_photo.url : ''
  end

  def car_thumb_url
     car_lincese_photo.thumb && car_lincese_photo.thumb.url ? CustomConfig::HOST + car_lincese_photo.thumb.url : ''
  end 

  def car_url
     car_lincese_photo && car_lincese_photo.url ? CustomConfig::HOST + car_lincese_photo.url : ''
  end

  def livecard_front_thumb_url
     livecard_front_photo.thumb && livecard_front_photo.thumb.url ? CustomConfig::HOST + livecard_front_photo.thumb.url : ''
  end 

  def livecard_front_url
     livecard_front_photo && livecard_front_photo.url ? CustomConfig::HOST + livecard_front_photo.url : ''
  end

  def livecard_back_thumb_url
     livecard_back_photo.thumb && livecard_back_photo.thumb.url ? CustomConfig::HOST + livecard_back_photo.thumb.url : ''
  end 

  def livecard_back_url
     livecard_back_photo && livecard_back_photo.url ? CustomConfig::HOST + livecard_back_photo.url : ''
  end

  def lincese_front_thumb_url
     lincese_front_photo.thumb && lincese_front_photo.thumb.url ? CustomConfig::HOST + lincese_front_photo.thumb.url : ''
  end 

  def lincese_front_url
     lincese_front_photo && lincese_front_photo.url ? CustomConfig::HOST + lincese_front_photo.url : ''
  end

  def lincese_back_thumb_url
     lincese_back_photo.thumb && lincese_back_photo.thumb.url ? CustomConfig::HOST + lincese_back_photo.thumb.url : ''
  end 

  def lincese_back_url
     lincese_back_photo && lincese_back_photo.url ? CustomConfig::HOST + lincese_back_photo.url : ''
  end

  def bank_card_photo_thumb_url
     bank_card_photo.thumb && bank_card_photo.thumb.url ? CustomConfig::HOST + bank_card_photo.thumb.url : ''
  end 

  def bank_card_photo_url
     bank_card_photo && bank_card_photo.url ? CustomConfig::HOST + bank_card_photo.url : ''
  end

  def map_thumb_url
     # avatar.thumb && avatar.thumb.url ? CustomConfig::HOST + avatar.thumb.url : ''
     map && map.file ? MapPhoto::qiniu_bucket_domain + map.file.path : ''

  end 

  def map_url
     map && map.file ? MapPhoto::qiniu_bucket_domain + map.file.path+'?imageMogr2/thumbnail/100x100' : ''
  end

  def driving_age 
    start_drive ? ((DateTime.now - start_drive)/365).to_i  : 5
  end

  def teaching_age 
    start_teach ? ((DateTime.now - start_teach)/365).to_i  : 1
  end

  def self.get_status
    return {'待审核'=>'200', '审核通过'=>'201', '审核不通过'=>'0', '已经报名，待审核' => '100'}
  end

  def set_status
    case self.status
    when 200
      return '待审核'
    when 201
      return '审核通过'
    when 0
      return '审核不通过'
    when 100
      return '已经报名，待审核'
    end
  end

  def self.get_flag
    {'正常使用' => 1, '休假' => 0}
  end

  def self.get_vip
    {'VIP' => 1, '普通' => 0}
  end

  def set_flag
    case self.status_flag
    when 1
      return '正常使用'
    when 0
      return '休假'
    end
  end

  def self.status_flag 
    {"休假" =>0 , "正常使用" =>1}
  end

  def format_created
    created_at.strftime('%Y-%m-%d')
  end

  def comment_size
    comments.size
  end

  def created_at_format 
    created_at.strftime('%m月%d日 %H:%m')
  end

  def status_color 
    case self.status
    when 0
      return 'danger'
    when 201
      return 'success'
    when 200
      return 'info'
    when 100
      return 'warning'
    end

  end


  def status_flag_color 
    case self.status_flag
    when 0
      return 'danger'
    when 1
      return 'success'
    end
  end

  def rate_color
    case 
    when self.rate < 4
      return 'danger'
    else
    return 'success'
    end
  end

  def app_color
    case
    when self.login_count > 0
      return 'success'
    else
      return 'danger'
    end
  end

  def is_login
    case
    when self.login_count > 0
      return '有'
    else
      return '未'
    end
  end

  def self.has_app
    {"未" => 0, "有" => 1}
  end


  def self.exam_type
    {"未知" => 1, "C1" => 2, "C2" => 3, "C1/C2" => 4}
  end

  def exam_type_word 
    case exam_type
    when 2
      return 'C1'
    when 3
      return 'C2'
    when 4
      return 'C1/C2'
    else
      return 'C1'
    end
  end

  def msg
    i = 0
    return 0 if teacher_audit.nil? 

    i += 1 if teacher_audit.photo == 1
    i += 1 if teacher_audit.id_card == 1
    i += 1 if teacher_audit.bank_card == 1
    i += 1 if teacher_audit.mobile == 1
    i += 1 if teacher_audit.place_confirm == 1

    return i
  end

  def self.authenticate(mobile, password)
    teacher = first(:conditions => ["lower(mobile) = lower(?)", mobile]) if mobile.present?
    teacher && teacher.has_password?(password) ? teacher : nil
  end

  def self.find_by_id(id)
    get(id) rescue nil
  end

  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  def password_required
    crypted_password.blank? || password.present?
  end

  def encrypt_password
    self.crypted_password = ::BCrypt::Password.create(password) if password.present?
  end

  #教练空闲时刻表
  def date_setting_filter
      JSON.parse(date_setting)
    rescue => err 
      return JSON.parse('{"week":[0,1,2,3,4,5,6],"time":[7,20]}')
  end

  def self.open
    return {'开' => 1, '关' => 0}
  end

  def self.tech_type
    return {'科目二/科目三' => 1, '科目二' => 2, '科目三' => 3}
  end


  def tech_type_word
    case self.tech_type
    when 1
      return '科目二/科目三'
    when 2
      return '科目二' 
    when 3
      return '科目三' 
    end
  end


  def tech_type_name
    case self.tech_type
    when 1
      return '科目二/科目三'
    when 2
      return '科目二' 
    when 3
      return '科目三' 
    end
  end

  #更新旧数据
  def refresh_tech_hours
    if self.tech_hours != self.has_hour
      self.tech_hours = self.has_hour
    end
    self.save
  end

  def train_field_str
    train_fields.map(&:name).join(',')
  end
  # 是否VIP教练
  def vip?
    vip == 1
  end

  def reset_subject
    subject_arr = train_fields.map(&:subject).uniq
    if subject_arr == [2]
      code = 2
    elsif subject_arr == [3]
      code = 3
    else
      code = 0
    end
    self.update(:subject => code)
  end

  #学员可预约时间
  def time_can_book 
    #/*获取教练自定义接单时间
    setting_time = date_setting_filter["time"].map{ |data| data.to_i }
    teacher_setting_time = []
    setting_time[0].upto(setting_time[1]).each do |i|
      teacher_setting_time << i
    end
    teacher_setting_week = date_setting_filter["week"].map{ |data| data.to_i }
    #获取教练自定义接单时间*/

    tmp          = []
    time_between = (Date.today+1)..(Date.today+8.day)
    orders(:status => Order::pay_or_done, :book_time => time_between ).each do |order|
      tmp << order.book_time.strftime('%Y-%m-%d %k:00')
      tmp << (order.book_time+1.hour).strftime('%Y-%m-%d %k:00') if order.quantity == 2
    end
    #生成近7天的预订情况
    array = []
    (1..7).each do |i|
       current_date = (Date.today+i).strftime('%Y-%m-%d')
       week = (Date.today+i).strftime('%w') 
       date_time=[]
       time_array = []
       (0..23).each do |time|
          temp_time = time
          time = " #{time}" if time < 10
          #如果该时间已经被预订，则显示不可约 0
          if tmp.include?(current_date+" #{time}:00") || (Time.now.strftime('%H').to_i > 17 && i == 1 ) || !teacher_setting_time.include?(temp_time) || !teacher_setting_week.include?((Date.today+i.days).wday)
            time_array << 0
          else
            time_array << 1
          end
       end
       array << time_array
    end
    result = {}
    result.store('data', array)
    result.store('status', 'success')
    result.to_json
  end

  def check_order
    # 把订单已结束，但未点完成的订单，修改状态
    old_orders = overdue_undone_orders
    old_orders.each do |order|
      order.status = Order::STATUS_DONE
      order.save
    end
  end

  def my_train_field
    train_fields.all(:open => 1)
  end

  # 已结束，但点完成的订单
  def overdue_undone_orders
    date = Time.now - 1.hour
    # 已支付 + 已确认
    orders.all(:status=>[1, 2], :book_time.lt => date)
  end

  def done_orders
    orders.all(:status => [3, 4])
  end

  def done_or_cancel_orders
    orders.all(:status => [3, 4, 5, 6])
  end

  def waiting_count
    order_array = []
    order_confirm = OrderConfirm.all(:teacher_id => id, :status => 0, :order => :created_at.desc )

    order_confirm.each do |oc|
      order = oc.order
      order_array << order if order && order.book_time > Time.now && order.status == Order::STATUS_PAY
    end

    order_array.count
  end

  def exam_type_demo
    '驾考类型: 1=>未知, 2=>C1, 3=>C2, 4=>C1/C2'
  end

  def tech_type_demo
    '教授科目:  1=>科目二/科目三, 2=>科目二, 3=>科目三'
  end

  def sex_demo
    '性别: 0=>女 1=>男'
  end
end
