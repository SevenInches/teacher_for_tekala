class Order
  include DataMapper::Resource
  attr_accessor :no_jpush
  attr_accessor :before_status

  STATUS_PAY        = 1   # 待接单
  STATUS_RECEIVE    = 2   # 已接单
  STATUS_COMMENT    = 3   # 待评价
  STATUS_DONE       = 4   # 已完成
  STATUS_REFUSE     = 5   # 已拒单
  STATUS_CANCEL     = 5   # 已拒单

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
  property :book_time,  DateTime

  #是否已经买了保单
  property :has_insure, Integer, :default => 0

  property :confirm, Integer, :default => 0 #教练或者后台是否已经确定处理该订单 0未处理

  property :ch_id, String #ping++ ch_id


  #'待接单'=>1, '已接单'=>2, '待评价'=>3, '已完成' =>4, '已拒单' => 5, '已取消'=>6
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

  property :pay_channel, String, :default => ''

  belongs_to :user
  belongs_to :teacher
  belongs_to :train_field

  has 1, :user_comment

  #教练接单
  has 1, :order_confirm

  after :save do
  #推送并创建一个让教练点确定的订单
    if status == STATUS_PAY
      order_confirm = OrderConfirm.first(:teacher_id => teacher_id, :start_at => (book_time..(book_time + quantity.hour)), :end_at => (book_time..(book_time + quantity.hour)) )
      confirm_status = order_confirm.nil? ? 0 : 2
      current_confirm = OrderConfirm.create(
                                            :order_id   => id,
                                            :teacher_id => teacher_id,
                                            :user_id    => user_id,
                                            :start_at   => book_time,
                                            :end_at     => book_time + quantity.hour,
                                            :status     => confirm_status )
    end


    if status == STATUS_RECEIVE || status == STATUS_DONE
      self.update(:done_at => Time.now)
    end
  end


  def cancel_by_me
    (status == STATUS_REFUSE && order_confirm && order_confirm.status == 2) ? true : false
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
    return "#{year}#{month}#{day}#{hour}#{min}#{sec}#{rands}#{user_id}".to_s
  end

  def self.get_status
    return {'待接单'=>1, '已接单'=>2, '待评价'=>3, '已完成' =>4, '已拒单' => 5, '已取消'=>6}
  end

  def set_status
    case self.status
      when 1
        return '待接单'
      when 2
        return '已接单'
      when 3
        return '待评价'
      when 4
        return '已完成'
      when 5
        return '已拒单'
      when 6
        return '已取消'
    end
  end

  def status_word
    case self.status
      when 1
        return '待接单'
      when 2
        return '已接单'
      when 3
        return '待评价'
      when 4
        return '已完成'
      when 5
        return '已拒单'
      when 6
        return '已取消'
    end
  end

  def status_word_html
    case self.status
      when 1
        return '<span class="order-status order-status-1">待接单</span>'
      when 2
        return '<span class="order-status order-status-2">已接单</span>'
      when 3
        return '<span class="order-status order-status-3">待评价</span>'
      when 4
        return '<span class="order-status order-status-4">已完成</span>'
      when 5
        return '<span class="order-status order-status-5">已拒单</span>'
      when 6
        return '<span class="order-status order-status-6">已取消</span>'
    end
  end

  def status_class
    case self.status
      when 1
        return 'wait-order'
      when 2
        return 'accept-order'
      when 3
        return 'wait-evaluate'
      when 4
        return 'complete'
      when 5
        return 'reject'
      when 6
        return 'cancel'
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


  # def can_comment
  #   return  status == STATUS_COMMENT && teacher_comment.nil? ? true : false
  # end
  #
  # def teacher_can_comment
  #   return  status == STATUS_COMMENT && user_comment.nil? ? true : false
  # end
  #
  # def user_has_comment
  #   teacher_comment.nil? ? false : true
  # end

  def is_comment
    user_comment.nil? ? false : true
  end

  def train_field_name
    train_field ? train_field.name :  teacher.training_field
  end

  def self.accept
    [2]
  end

  #教练是否已经接单
  def accept_status
    return 0 if order_confirm.nil?
    order_confirm.status
  end

  def self.pay_or_done
    [1,2,3,4]
  end

  def self.cancel
    [5,6]
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

  def status_demo
    '订单状态: 待接单=>1, 已接单=>2, 待评价=>3, 已完成=>4, 已拒单=>5, 已取消=>6'
  end

  def book_time_conversion
    hour = quantity ? quantity : '0'
      book_time.strftime("%Y年%m月%d日 %H") + '点-' + (book_time + quantity.to_i.hours).strftime("%H") +'点, ' + hour.to_s + '小时'
  end

end
