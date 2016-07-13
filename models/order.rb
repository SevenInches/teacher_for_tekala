class Order
  include DataMapper::Resource
  attr_accessor :no_jpush
  attr_accessor :before_status

  VIPTYPE       = 1
  NORMALTYPE    = [1,2]
  PAYTOTEACHER  = 1
  FREETOTEACHER = 2

  STATUS_CANCEL     = 7   # 取消状态
  STATUS_REFUNDING  = 5   # 退款中
  #补贴

  C2_ALLOWANCE = 10

  #收佣金
  REBATE       = 0.1

  property :id, Serial
  property :user_id, Integer
  property :teacher_id, Integer
  property :train_field_id, Integer
  property :school_id, Integer
  property :city_id, Integer
  property :order_no, String
  property :amount, Float
  property :discount, Float, :default => 0.0
  property :subject, Text, :lazy => false, :default => ''
  property :quantity, Integer #学时数量
  property :price, Float #单价
  property :note, String, :default => ''
  property :device, String, :default => ''

  property :pay_at,     DateTime
  property :done_at,    DateTime
  property :cancel_at,  DateTime
  property :created_at, DateTime
  property :updated_at, DateTime
  property :book_time,  DateTime  #预订时间

  #是否已经买了保单
  property :has_insure, Integer, :default => 0

  property :confirm, Integer, :default => 0 #教练或者后台是否已经确定处理该订单 0未处理

  property :ch_id, String #ping++ ch_id


  #'未支付'=>1, '已预约'=>2, '已完成'=>3, '已确定'=>4, '退款中' => 5, '已退款' => 6, '取消'=>7
  property :status, Integer, :default => 1

  #'练车预约订单' => 1, '打包订单' => 2, '活动预付款' => 3
  property :type, Integer, :default => 1 #2 为无需记录学时

  #'C1' => 1, 'C2' => 2
  property :exam_type, Integer, :default => 1 #学车类型

  #'普通订单' => 1, '会员的订单' =>2
  property :vip, Integer, :default => 1

  #学车进度 {"科目二" => 1, "科目三" => 2}
  property :progress, Integer

  property :remark, String

  # mok 经纬度 2015-09-07
  property :latitude, String
  property :longitude, String

  property :has_sms, Integer, :default => 0

  #mok 产品id号 2015-09-30
  property :product_id, Integer, :default => 0
  property :city_id, Integer

  property :theme, String

  #结算时间
  property :sum_time, DateTime

  property :pay_channel, String

  belongs_to :user
  belongs_to :teacher
  belongs_to :train_field


  has 1, :user_coupon

  has 1, :teacher_comment

  has 1, :user_comment

  #教练接单
  has 1, :order_confirm

  # after_create :send_sms

  # after :create do |order|
  #     JPush.send "#{user.name}创建了订单"
  #     order_confirm = OrderConfirm.first(:teacher_id => teacher_id, :start_at => (book_time..(book_time + quantity.hour)), :end_at => (book_time..(book_time + quantity.hour)), :status.not => 2)
  #     confirm_status = order_confirm.nil? ? 0 : 2
  #     current_confirm = OrderConfirm.create(
  #                                           :order_id   => id,
  #                                           :user_id    => user_id,
  #                                           :teacher_id => teacher_id,
  #                                           :user_id    => user_id,
  #                                           :start_at   => book_time,
  #                                           :end_at     => book_time + quantity.hour,
  #                                           :status     => confirm_status )


  # end

  after :save do

  #推送并创建一个让教练点确定的订单
  #   JPush.send "#{user.name}创建了订单"
    if status == 2
      order_confirm = OrderConfirm.first(:teacher_id => teacher_id, :start_at => (book_time..(book_time + quantity.hour)), :end_at => (book_time..(book_time + quantity.hour)) )
      confirm_status = order_confirm.nil? ? 0 : 2
      current_confirm = OrderConfirm.create(
                                            :order_id   => id,
                                            :user_id    => user_id,
                                            :teacher_id => teacher_id,
                                            :user_id    => user_id,
                                            :start_at   => book_time,
                                            :end_at     => book_time + quantity.hour,
                                            :status     => confirm_status )
      #JPush::order_confirm(current_confirm.order_id) if current_confirm && current_confirm.status == 0
    end


    #支付后购买保险
    # if status == 2  && has_insure == 1
    #   if insure.nil?
    #
    #     data = '{
    #               "REQUEST_CODE": "V2",
    #               "REQUEST_TYPE":"Request",
    #               "USER": "07",
    #               "PASSWORD": "123456",
    #               "PROD_ID":"2703",
    #               "DEPT_ID":"8000",
    #               "BASE_PART" :{
    #               "CERT_TYPE":"01",
    #               "CERT_ID":"'+user.id_card+'",
    #               "CLEINT_NAME":"'+user.name+'",
    #               "SEX":"'+(user.sex == 1 ? "M" : "F")+'",
    #               "EFFECTIVE_TM": "'+book_time.strftime('%Y%m%d%H%M%S')+'",
    #               "HOURS": "'+quantity.to_s+'",
    #               "ORDER_ID": "'+order_no+'",
    #               "INPUT_TM":"'+book_time.strftime('%Y%m%d')+'"
    #             }
    #           }
    #         '
    #     # puts data
    #     request = Curl::Easy.http_post(CustomConfig::INSURE, data ) do |curl|
    #                 curl.headers['Accept'] = 'application/json'
    #                 curl.headers['Content-Type'] = 'application/json'
    #               end
    #
    #     if request.body
    #
    #         begin
    #
    #           insure_info = JSON.parse(request.body)
    #           insure = Insure.new
    #           insure.request      = data
    #           insure.effective_tm = insure_info["EFFECTIVE_TM"] if insure_info["EFFECTIVE_TM"]
    #           insure.order_id     = id
    #           insure.order_no     = insure_info["ORDER_ID"]     if insure_info["ORDER_ID"]
    #           insure.expire_tm    = insure_info["EXPIRE_TM"]    if insure_info["EXPIRE_TM"]
    #           insure.pol_no       = insure_info["POL_NO"]       if  insure_info["POL_NO"]
    #           insure.amount       = insure_info["AMOUNT"]       if insure_info["AMOUNT"]
    #           insure.error_desc   = insure_info["error_desc"]   if insure_info["error_desc"]
    #           insure.premium      = insure_info["PREMIUM"]      if insure_info["PREMIUM"]
    #           insure.error_code   = insure_info["ERROR_CODE"]   if insure_info["ERROR_CODE"]
    #           insure.response     = request.body
    #           insure.save
    #
    #           puts "#{insure.errors.to_hash}==insure.errors.to_hash=="
    #       rescue => err
    #       ensure
    #       end
    #
    #    end
    #
    #   end
    # end

    if status == 3
      self.update(:done_at => Time.now)
    end


  end


  def cancel_by_me
    (status == 0 && order_confirm && order_confirm.status == 2) ? true : false
  end


  def generate_order_no
    year    = Time.now.year
    month   = "%02d" % Time.now.month
    day     = "%02d" % Time.now.day
    hour    = "%02d" % Time.now.hour
    min     = "%02d" % Time.now.min
    sec     = "%02d" % Time.now.sec
    user_id = self.user_id
    rands   = rand(9999)
    self.update(:order_no => "#{year}#{month}#{day}#{hour}#{min}#{sec}#{rands}#{user_id}".to_s)
  end

  def self.generate_order_no_h5
    year    = Time.now.year
    month   = "%02d" % Time.now.month
    day     = "%02d" % Time.now.day
    hour    = "%02d" % Time.now.hour
    min     = "%02d" % Time.now.min
    sec     = "%02d" % Time.now.sec
    user_id = self.user_id
    rands   = rand(9999)
    return "#{year}#{month}#{day}#{hour}#{min}#{sec}#{rands}".to_s
  end

  def self.get_status
    return {'未支付'=>'1', '等待接单'=>'2', '已确定'=>'4', '已完成'=>'3', '退款中'=>'5', '退款'=>'6', '取消'=>'7'}
  end

  def set_status
    case self.status
      when 1
        return '未支付'
      when 2
        return '等待接单'
      when 3
        return '已完成'
      when 4
        return '已确定'
      when 5
        return '退款中'
      when 6
        return '已退款'
      when 7
        return '已取消'
    end
  end

  def status_word
    case self.status
      when 1
        return '待支付'
      when 2
        return '等待接单'
      when 3
        if can_comment && !user_has_comment
          return '待评价'
        else
          return '已完成'
        end
      when 4
        return '已接单'
      when 5
        return '退款中'
      when 6
        return '已退款'
      when 7
        if accept_status == 2
          return '教练繁忙'
        else
          return '已取消'
        end
    end
  end

  def created_at_format
    created_at.strftime('%Y-%m-%d %H:%M')
  end

  def pay_at_format
   pay_at ? pay_at.strftime('%Y-%m-%d %H:%M') : ''
  end

  def promotion_amount
    promotion = amount.to_f-discount.to_f

    if promotion > 0
      self.update(:vip => 0)
      promotion
    else
      self.update(:vip => 1)
      0
    end
  end


  def can_comment
    return  status == 3 && teacher_comment.nil? ? true : false
  end

  def teacher_can_comment
    return  status == 3 && user_comment.nil? ? true : false
  end

  def user_has_comment
    teacher_comment.nil? ? false : true
  end

  def is_comment
    user_comment.nil? ? false : true
  end

  def train_field_name
    train_field ? train_field.name :  teacher.training_field
  end

  def self.accept
    [4]
  end

  #教练是否已经接单
  def accept_status
    return 0 if order_confirm.nil?
    order_confirm.status
  end

  def self.pay_or_done
    [2,3,4]
  end

  def self.theme
      {'车辆行驶准备'    => 0,
       '车辆基本操作'    => 1,
       '倒车入库'       => 2,
       '侧方停车'       => 3,
       '坡道停车和起步'  => 4,
       '曲线行驶'       => 5,
       '直角转弯'       => 6,
       '科目三训练项'    => 7}

  end

  def self.theme_api

      [{"name" => '车辆行驶准备', 'code' => 0},
       {"name" => '车辆基本操作', 'code' => 1},
       {"name" => '倒车入库', 'code' => 2},
       {"name" => '侧方停车', 'code' => 3},
       {"name" => '坡道停车和起步', 'code' => 4},
       {"name" => '曲线行驶', 'code' => 5},
       {"name" => '直角转弯', 'code' => 6}]

  end

  def theme_name(code)
    word = ''
    Order::theme_api.each do |theme|
       word = theme['name'] if theme['code'] == code
    end
    word
  end

  def theme_word
    word_arr = []
    theme ||= ''
    theme_arr = theme.split(',')
    theme_arr.each do |t|
      word_arr << theme_name(t.to_i) if !t.empty?
    end

    word_arr
  end

end
