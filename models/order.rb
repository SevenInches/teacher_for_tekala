class Order
  include DataMapper::Resource
  attr_accessor :no_jpush
  attr_accessor :before_status

  VIPTYPE       = 1
  NORMALTYPE    = [0,2]
  PAYTOTEACHER  = 0
  FREETOTEACHER = 2

  STATUS_PAY   = 102
  STATUS_DONE  = 103

  # property <name>, <type>
  property :id, Serial
  property :user_id, Integer, :auto_validation => false
  property :order_no, String, :auto_validation => false
  property :amount, Integer
  property :discount, Float, :default => 0.0
  property :teacher_id, Integer, :auto_validation => false
  property :subject, Text, :lazy => false, :default => ''
  property :quantity, Integer, :auto_validation => false
  property :price, Float, :auto_validation => false #单价
  property :note, String, :default => ''
  property :device, String, :auto_validation => false, :default => ''
  property :pay_at, DateTime, :auto_validation => false
  property :done_at, DateTime, :auto_validation => false
  property :cancel_at, DateTime, :auto_validation => false

  property :has_insure, Integer, :default => 0

  #'订单未完成暂不可评论'=>0, '订单已经完成 可评论'=>1, '订单评论完成' => 2
  # property :comment_status, Enum[0, 1, 2], :default => 0
  #训练场id
  property :train_field_id, Integer

  property :confirm, Integer, :default => 0 #管理员是否已经确认处理 0未处理

  property :created_at, DateTime
  property :updated_at, DateTime


  property :other_book_time, DateTime #备选的预订时间
  property :book_time, DateTime #预订时间

  property :ch_id, String #ping++ ch_id
  #'未支付'=>101, '已支付'=>102, '已完成'=>103, 退款中 => 2, 已退款 => 1, '取消'=>0 , '已确定' => '104', '已结算' => '105'
  property :status, Enum[101, 102, 103, 1, 0, 2, 104, 105], :default => 101


  #{:练车预约订单 => 0, :报名订单 => 1, :打包订单 => 2, :活动预付款 => 3}
  property :type, Enum[0, 1, 2, 3], :default => 0 #2 为无需记录学时

  #{"未知" => 0, "C1" => 1, "C2" => 2}
  property :exam_type, Enum[0, 1, 2], :default => 1 #学车类型

  #{:会员的订单 => 1, :普通订单 => 0}
  property :vip, Enum[0, 1], :default => 0

  property :has_sms, Integer, :default => 0

  property :theme, String

  #{:会员的订单 => 1, :普通订单 => 0} 2015-08-06 mok
  property :vip, Enum[0, 1], :default => 0

  property :sum_time, DateTime

  belongs_to :user
  belongs_to :teacher
  belongs_to :train_field


  has 1, :user_coupon

  has 1, :teacher_comment

  has 1, :user_comment

  #教练接单
  has 1, :order_confirm

  before :save do |order|
    #判断order的类型
    o = Order.get order.id
    self.before_status = o ? o.status : nil


    if self.before_status == 104 && self.status == 103
      pay_to_teacher
    end

    if self.before_status == 103 && self.status == 105
      freeze_to_active
    end
  end

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
    if status == 102
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
      JPush::order_confirm(current_confirm.order_id) if current_confirm && current_confirm.status == 0
    end
    #统计来源 状态为支付 类型是 3800包过班 通过微信支付渠道

    if status == 102 && type == 1 && user && promotion = user.promotion_user
      return if promotion.wechat_unionid.nil?

      promotion_channel = PromotionChannel.first(:from => promotion.wechat_unionid)

      return if promotion_channel.nil?

      data = ChannelData.first_or_create(:event_key => promotion_channel.event_key, :date => Date.today.strftime('%Y%m%d'))
      data.pay_count = data.pay_count.to_i + 1
      data.save

    end

    #支付后购买保险
    if status == 102  && has_insure == 1
      if insure.nil?

        data = '{
                  "REQUEST_CODE": "V2",
                  "REQUEST_TYPE":"Request",
                  "USER": "07",
                  "PASSWORD": "123456",
                  "PROD_ID":"2703",
                  "DEPT_ID":"8000",
                  "BASE_PART" :{
                  "CERT_TYPE":"01",
                  "CERT_ID":"'+user.id_card+'",
                  "CLEINT_NAME":"'+user.name+'",
                  "SEX":"'+(user.sex == 1 ? "M" : "F")+'",
                  "EFFECTIVE_TM": "'+book_time.strftime('%Y%m%d%H%M%S')+'",
                  "HOURS": "'+quantity.to_s+'",
                  "ORDER_ID": "'+order_no+'",
                  "INPUT_TM":"'+book_time.strftime('%Y%m%d')+'"
                }
              }
            '
        # puts data
        request = Curl::Easy.http_post(CustomConfig::INSURE, data ) do |curl|
                    curl.headers['Accept'] = 'application/json'
                    curl.headers['Content-Type'] = 'application/json'
                  end

        if request.body

            begin

              insure_info = JSON.parse(request.body)
              insure = Insure.new
              insure.request      = data
              insure.effective_tm = insure_info["EFFECTIVE_TM"] if insure_info["EFFECTIVE_TM"]
              insure.order_id     = id
              insure.order_no     = insure_info["ORDER_ID"]     if insure_info["ORDER_ID"]
              insure.expire_tm    = insure_info["EXPIRE_TM"]    if insure_info["EXPIRE_TM"]
              insure.pol_no       = insure_info["POL_NO"]       if  insure_info["POL_NO"]
              insure.amount       = insure_info["AMOUNT"]       if insure_info["AMOUNT"]
              insure.error_desc   = insure_info["error_desc"]   if insure_info["error_desc"]
              insure.premium      = insure_info["PREMIUM"]      if insure_info["PREMIUM"]
              insure.error_code   = insure_info["ERROR_CODE"]   if insure_info["ERROR_CODE"]
              insure.response     = request.body
              insure.save

              puts "#{insure.errors.to_hash}==insure.errors.to_hash=="
          rescue => err
          ensure
          end

       end

      end
    end

    if status == 103
      self.update(:done_at => Time.now)
    end

    #返回代金券
    return_coupon

  end


  def return_coupon

    if status == 0 && no_jpush != true

      coupon = UserCoupon.first(:order_id => id)
      if coupon
        coupon.status = 1
        coupon.order_id = nil
        coupon.save
      end
    end

    if status == 102 && no_jpush != true
      JPush.send "#{user.name}创建了支付了该订单"
    end

  end

  def has_coupon
    user_coupon ? true :false
  end

  def cancel_by_me
    (status == 0 && order_confirm && order_confirm.status == 2) ? true : false
  end


  def book_time_format
    book_time.strftime('%Y-%m-%d %H:%M:%ss')
  end

  #给教练打钱
  def pay_to_teacher
    self.teacher.freeze_money += self.amount.to_i
    self.teacher.save
  end

  #冻结转可提现
  def freeze_to_active
    self.teacher.freeze_money -= self.amount.to_i
    self.teacher.withdraw_money += self.amount.to_i
    self.teacher.save
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

  def book_time_format
    book_time ? book_time.strftime('%Y-%m-%d %H:%M') : ''
  end


  def other_book_time_format
    other_book_time ? other_book_time.strftime('%Y-%m-%d %H:%M') : ''
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
    return {'未支付'=>'101', '已支付'=>'102', '已确定'=>'104', '已完成'=>'103', '退款中'=>'2', '退款'=>'1', '取消'=>'0'}
  end

  def set_status
    case self.status
    when 101
      return '未支付'
    when 102
      return '已支付'
    when 103
      return '已完成'
    when 104
      return '已确定'
    when 2
      return '退款中'
    when 1
      return '已退款'
    when 0
      return '已取消'
    end
  end

  def status_word
    case self.status
    when 101
      return '待支付'
    when 102
      return '等待接单'
    when 103
      if can_comment && !user_has_comment
       return '待评价'
      else
       return '已完成'
      end
    when 104
       return '已接单'
    else
        return '已取消'
    end
  end

  #是否已经结算
  def paid
    if self.status == 103
      time_difference = (DateTime.parse(Time.now.strftime('%Y-%m-%d')) - DateTime.parse(self.book_time.strftime('%Y-%m-%d')) ).to_i
      if time_difference > 7
        true
      else
        false
      end
    else
      false
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

  def self.type
    {'普通班' => 0, '包过班' => 1}
  end

  def type_word
    case type
    when 1
      '包过班'
    else
      '普通班'
    end
  end

  def can_comment
    return  status == 103 && teacher_comment.nil? ? true : false
  end

  def teacher_can_comment
    return  status == 103 && user_comment.nil? ? true : false
  end

  def user_has_comment
    teacher_comment.nil? ? false : true
    # TeacherComment.first(:order_id => id).nil? false : true
  end

  def is_comment
    user_comment.nil? ? false : true
  end

  def train_field_name
    train_field ? train_field.name :  teacher.training_field
  end

  def self.accept
    [104]
  end

  #教练是否已经接单
  def accept_status
    return 0 if order_confirm.nil?
    order_confirm.status
  end

  def self.pay_or_done
    [102,103,104]
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
