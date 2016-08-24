class School
  include DataMapper::Resource

  attr_accessor :password

  # property <name>, <type>
  property :id, Serial
  property :city_id, Integer
  property :school_no, String
  property :name, String
  property :address, String
  property :contact_phone, String
  property :profile, Text   #简介
  property :is_vip, Boolean #vip
  property :is_open, Boolean, :default => 1 #是否开放
  property :weight, Integer  #权重
  property :master, String   #校长
  property :logo, String     #logo
  property :found_at, Date
  property :latitude, String
  property :longitude, String
  property :config, Text     #配置
  property :note, String
  property :created_at, DateTime
  property :updated_at, DateTime

  #新增字段
  #property :contact_user, String
  #property :teacher_count, Integer
  #property :car_count, Integer
  #property :area_count, Integer
  #property :shop_count, Integer
  #1-10，五星好评，9代表4.5星
  #property :rank, Integer

  belongs_to :city

  #has n, :maps  # 训练场数字地图

  has n, :branches  #校区
  has n, :shops # 门店
  has n, :cars  #车辆
  #has n, :finances          # 财务记录
  #has n, :finance_reports   # 财务报告
  #has n, :logs  # 操作日志
  has n, :products #产品
  has n, :users
  has n, :signups
  has n, :teachers
  has n, :train_fields
  has n, :roles
  has n, :pushes
  has n, :news
  has n, :dailies

  before :save, :encrypt_password

  def user_num
    month_beginning = Date.strptime(Time.now.beginning_of_month.to_s,'%Y-%m-%d')
    this_month = month_beginning  .. Date.tomorrow
    users.count(:signup_at => this_month)
  end

  def signup_amount
    month_beginning = Date.strptime(Time.now.beginning_of_month.to_s,'%Y-%m-%d')
    this_month = month_beginning  .. Date.tomorrow
    amount = signups.all(:created_at => this_month, :status => 2).sum(:amount)
    amount.present? ? amount.round(2) : 0
  end

  def city_name
    city.nil? ? '--' : city.name
  end

  def self.first_school_id(school)
    current = self.first(:name.like => "%#{school}%")
    current.id if current.present?
  end

end

