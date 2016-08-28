#学员管理
class User
  include DataMapper::Resource
  attr_accessor :beta
  attr_accessor :rank, :password, :login_action, :section, :wechat_avatar, :wechat_unionid, :group_name #内测第几批学员
  attr_accessor :before_product_id
  VIP    = 1
  NORMAL = 0
  # property <name>, <type>

  property :id, Serial
  property :id_card, String

  property :crypted_password, String, :length => 70
  property :name, String

  property :mobile, String, :required => true, :unique => true,
           :messages => {
               :presence  => "手机号不能为空",
               :is_unique => "手机号已被注册"
           }

  property :city_id, Integer
  property :started_at, DateTime
  property :sex, Integer, :default => 0
  property :age, Integer
  property :avatar, String
  property :score, Integer, :default => 0
  property :birthday, Date

  property :daily_limit, Integer
  #{"未知" => 0, "C1" => 1, "C2" => 2}
  property :exam_type, Integer, :default => 1                     #报名类型

  #{"注册" => 0, "已付费" => 1, "拍照" => 2, "体检" => 3, "录指纹" => 4, "科目一" => 5, "科目二" => 6, "科目三" => 7, "考长途" => 8, "科目四" => 9, "已拿驾照" => 10, "已离开" => 11, "已入网" => 12}
  property :status_flag, Integer, :default => 0

  # property :last_login, DateTime
  property :last_login_at, DateTime
  property :device, String
  property :version, String

  property :motto, String

  property :created_at, DateTime
  property :updated_at, DateTime

  # {:普通班 => 0, :包过班 => 1} 订单交付类型 2015-07-20 mok
  property :type, Integer, :default => 0

  property :address, String

  property :email, String
  #用户区域

  property :live_card, Integer

  # mok 经纬度 2015-09-07
  property :latitude, String
  property :longitude, String

  #mok 统计学习时长 2015-09-29
  property :learn_hours, Integer
  property :pay_type_id, Integer

  property :nickname, String

  property :referer, String

  #用户车管所预约数据
  property :photo_receipt, String
  property :book_account, String
  property :book_password, String
  property :id_card_address, String
  property :fee_receipt, String

  #邀请码
  property :invite_code, String

  property :from_code, String

  property :product_id, Integer, :default => 11

  property :school_id, Integer

  property :branch_id, Integer

  property :product_id, Integer

  property :shop_id, Integer

  #登陆次数
  property :login_count, Integer, :default => 0

  property :teacher_id, Integer
  property :train_field_id, Integer

  property :cash_name, String
  property :cash_mobile, String
  property :cash_bank_name, String
  property :cash_bank_card, String
  property :signup_at, Date

  #来源 1=>转介绍, 2=>网络, 3=>门店, 4=>熟人
  property :origin,  Integer

  #所在地 1=>本地, 2=>外地
  property :local, Integer, :default => 1

  property :manager_no, String

  property :operation_no, String

  #申请类型: 1=>初次 2=>增驾
  property :apply_type, Integer

  #支付类型: 1=>微信 2=>支付宝 3=>POS机 4=>现金
  property :pay_type, Integer

  has n, :orders

  has n, :comments, :model => 'TeacherComment', :child_key =>'user_id'

  has n, :cycles, :model => 'UserCycle', :child_key =>'user_id'

  has n, :pays, :model => 'UserPay', :child_key =>'user_id'

  has 1, :signup

  has 1, :user_plan, :constraint => :destroy

  has 1, :user_exam, :constraint => :destroy

  #教练接单
  has n, :order_confirms, :model => 'OrderConfirm', :child_key => 'user_id', :constraint => :destroy

  has n, :feedbacks         # 反馈
  has n, :complains         # 投诉

  belongs_to :product
  belongs_to :teacher
  belongs_to :train_field

  belongs_to :school

  belongs_to :city

  belongs_to :branch

  belongs_to :shop

  # Callbacks
  before :save, :encrypt_password

  after :save do
    UserPlan.first_or_create(:user_id => id)
    UserExam.first_or_create(:user_id => id)
  end

  def last_book_at
    last_order = orders.last
    last_order.present? ? last_order.book_time : ''
  end

  def product_name
    product ? product.name : 'Error未指定产品'
  end

  #已完成学时
  def has_hour
    user_plan.present? ? (user_plan.exam_two + user_plan.exam_three) : 0
  end


  def avatar_thumb_url
    if avatar
      CustomConfig::QINIUURL+avatar.to_s+'?imageView2/1/w/200/h/200'
    else
      CustomConfig::HOST + '/images/icon180.png'
    end
  end

  def city_name
    city.name if city.present?
  end

  def avatar_url
    if avatar
      CustomConfig::QINIUURL+avatar.to_s
    else
      CustomConfig::HOST + '/images/icon180.png'
    end
  end

  def self.authenticate(id_card, password)
    user = first(:conditions => ["lower(id_card) = lower(?)", id_card]) if id_card.present?
    if user && user.has_password?(password)
      user.last_login_at = Time.now
      user.save
    end

    user && user.has_password?(password) ? user : nil
  end

  def self.authenticate_by_mobile(mobile, password)
    user = first(:conditions => ["lower(mobile) = lower(?)", mobile]) if mobile.present?
    if user && user.has_password?(password)
      user.last_login_at = Time.now
      user.save
    end
    user && user.has_password?(password) ? user : nil
  end

  def self.find_by_id(id)
    get(id) rescue nil
  end

  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  def date_format
    created_at.strftime('%Y-%m-%d')
  end

  def sex_format
    sex == 1 ? '男' : '女'
  end

  def password_required
    crypted_password.blank? || password.present?
  end

  def encrypt_password
    self.crypted_password  = ::BCrypt::Password.create(password) if password.present?
    current_user = User.get id
    self.before_product_id = current_user ? current_user.product_id : nil
    self.exam_type = 1 if self.exam_type.nil?
  end

  def self.status_flag
    {"注册" => 0, "已付费" => 1, "已入网" => 12,"拍照" => 2, "体检" => 3, "录指纹" => 4, "科目一" => 5, "科目二" => 6, "科目三" => 7, "考长途" => 8, "科目四" => 9, "已拿驾照" => 10, "已离开" => 11}
  end

  def status_flag_word
    case status_flag
      when 1
        "已付费"
      when 2
        "拍照"
      when 3
        "体检"
      when 4
        "录指纹"
      when 5
        "科目一"
      when 6
        "科目二"
      when 7
        "科目三"
      when 8
        "考长途"
      when 9
        "科目四"
      when 10
        "已拿驾照"
      when 11
        "已离开"
      else
        "注册"
    end
  end

  def self.exam_type
    {"C1" => 1, "C2" => 2}
  end

  def exam_type_word
    return 'C2' if exam_type == 2
    'C1'
  end

  def real_age
    if id_card.to_s.length == 18
      age = 2015 - id_card[6,4].to_i
      age > 0 ? age : 0
    else
      age = 0
    end
    age
  end

  # 给用户发送短信
  def send_sms(type)
    if Padrino.env == :production
      if type == :signup
        content = "#{name}学员，恭喜您已经成功注册萌萌学车帐号。您的登录帐号为：#{mobile}。在使用萌萌学车服务过程中，有任何问题欢迎通过微信公众号或者电话4008-456-866进行咨询。祝您学车愉快。"
        sms = Sms.new(:content => content, :member_mobile  => mobile)
        sms.signup
      end
    end
  end

  #是否打包教练
  def has_assign
    if self.teacher_id.nil? || self.teacher_id == 0
     false
    else
      true
    end
  end


  ##########
  #
  #desc 检查用户是否可以下单
  #@params
  #env:hash app版本信息等
  #teacher:object 教练
  #book_time:string 预约时间
  #
  ##########
  def can_book_order(env, order, book_time)
    #/*如果用户是在科目一则不能下单
    teacher     = order.teacher
    train_field = order.train_field

    if status_flag <= 5 && type == User::VIP
      return {:status   => :failure,
              :msg      => '需通过科目一考试后才可进行预约练车。如已通过科目一考试，请联系小萌更新学习进度哦~',
              :err_code => 2001 }
    end
    #如果用户是在考科目一则不能下单*/

    #limit
    #/*学时限制
    if status_flag < 7
      if user_plan.exam_two + order.quantity > user_plan.exam_two_standard
        return {:status => :failure,
                :msg    => '您当前科目的预约学时已达到小萌建议的学习时长，还没学会？请让小萌了解您的学车进度，提出申请后再进行预约。',
                :code   => 2002 }
      end
    else
      if user_plan.exam_three + order.quantity > user_plan.exam_three_standard
        return {:status => :failure,
                :msg    => '您当前科目的预约学时已达到小萌建议的学习时长，还没学会？请让小萌了解您的学车进度，提出申请后再进行预约。',
                :code   => 9003 }

      end
    end
    #学时限制 */

    #判断教练是否存在
    return {:status => :failure, :msg => '未能找到该教练', :err_code => 1001}  if teacher.nil?
    if teacher.train_fields.first(:id => train_field.id).nil?
      return {:status => :failure, :msg => '该教练已不在该训练场', :err_code => 1002}
    end
    #/*预订的日期
    book_time_first = (book_time.to_time).strftime('%Y-%m-%d %k:00')
    book_time_second = (book_time.to_time + 1.hours).strftime('%Y-%m-%d %k:00') if order.quantity == 2

    tmp = []
    Order.all(:teacher_id => teacher.id, :status => Order::pay_or_done, :book_time => ((Date.today+1)..(Date.today+8.day))).each do |order|
      tmp << order.book_time.strftime('%Y-%m-%d %k:00')
      tmp << (order.book_time+1.hour).strftime('%Y-%m-%d %k:00') if order.quantity == 2
    end
    # 预订的日期 */

    #/* 不能预约当天时间
    if book_time.to_date <= Date.today
      return {:status => :failure, :msg => '不能预约当天/之前时间练车'}
    end
    # 不能预约当天时间*/

    #/*如果现在时间是18点 则不允许预约隔天的
    if Time.now.strftime('%H').to_i > 17 &&  book_time.to_time <= (Date.today + 2.days).to_time
      return {:status => :failure, :msg => '18点后不能预约第二天练车'}
    end
    #如果现在时间是18点 则不允许预约隔天的*/

    #limit
    #/*如果该时段被预约 返回failure
    return {:status => :failure, :msg => '第一个时段已被预约'} if tmp.include?(book_time_first)
    return {:status => :failure, :msg => '第二个时段已被预约'} if tmp.include?(book_time_second)
    #如果该时段被预约 返回failure */
    #limit

    # /*限制用户一天只能约N个小时
    tmp = []
    Order.all(:user_id => id, :status => Order::pay_or_done, :book_time => ((book_time_first.to_date)..(book_time_first.to_date+1.day))).each do |order|
      tmp << order.book_time.strftime('%Y-%m-%d %k:00')
      tmp << (order.book_time+1.hour).strftime('%Y-%m-%d %k:00') if order.quantity == 2
    end

    days_count   = tmp.map{|val| val[0..9] }.count(book_time_first[0..9])
    days_current = days_count
    days_count  += order.quantity #今天学时
    return {:status => :failure, :msg => "您当天已学 #{days_current} 个学时，为保证教学质量，防止疲劳学习，建议一天最多学习 #{daily_limit} 小时哦！"} if days_count > daily_limit
    # 限制用户一天只能约4个小时 */
    return {:status => :success}
  end

  def status_flag_demo
    '学员状态: 0=>注册, 1=>已付费, 2=>拍照, 3=>体检, 4=>录指纹, 5=>科目一, 6=>科目二, 7=>科目三, 8=>考长途, 9=>科目四, 10=>已拿驾照, 11=>已离开, 12=>已入网'
  end

  def exam_type_demo
    '驾考类型: 0=>未知, 1=>C1, 2=>C2, 3=>C1/C2'
  end

  def type_demo
    '班别类型: 0=>普通班, 1=>包过班'
  end

  def origin_demo
    '来源: 1=>转介绍 2=>网络 3=>门店 4=>熟人'
  end

  def local_demo
    '所在地: 1=>本地 2=>外地'
  end

  def apply_type_demo
    '申请类型: 1=>初次 2=>增驾'
  end

  def pay_type_demo
    '支付类型: 1=>微信 2=>支付宝 3=>POS机 4=>现金'
  end

  def self.exam_type_reverse(exam_type)
    if exam_type == 'C2'
      2
    else
      1
    end
  end

  def self.status_flag_reverse(status_flag)
    status = {
        "注册" => 0,
        "已付费" => 1,
        "拍照" => 2,
        "体检" => 3,
        "录指纹" => 4,
        "科目一" => 5,
        "科目二" => 6,
        "科目三" => 7,
        "考长途" => 8,
        "科目四" => 9,
        "已拿驾照" => 10,
        "已离开" => 11
    }
    status[status_flag] if status[status_flag]
  end

end
