class School
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :city_id, Integer
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
  property :crypted_password, String

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

  #has n, :shops # 门店
  #has n, :finances          # 财务记录
  #has n, :finance_reports   # 财务报告
  #has n, :logs  # 操作日志
  has n, :products #产品
  has n, :users

  # def user_num
  #   users.all(:).count
  # end

  def city_name
    city.nil? ? '--' : city.name
  end

end

