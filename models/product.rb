#班别产品
class Product
  include DataMapper::Resource

  property :id, Serial
  property :city_id, Integer
  property :name, String
  property :price, Integer #单位 分
  property :detail, Text
  property :deadline, Date, :default => '2050-01-01' #截止日期
  property :created_at, DateTime
  property :updated_at, DateTime
  property :show, Integer, :default => 1
  property :photo, String, :auto_validation => false

  property :info_photo, String, :auto_validation => false
  property :exam_two_standard, Integer, :default => 0
  property :exam_three_standard, Integer, :default => 0
  property :total_quantity, Integer, :default => 0

  property :description, String

  property :introduction, String

  #"c1"=>1,"c2"=>2
  property :exam_type, Integer, :default => 0

  property :color, String, :default => ''                             #颜色

  #包含服务
  property :services, Text, :auto_validation => false
  #不含服务
  property :unservices, Text, :auto_validation => false
  #训练车品牌
  property :car, String, :auto_validation => false
  #科目二学时
  property :level_two_hours, Integer, :auto_validation => false
  #科目三学时
  property :level_three_hours, Integer, :auto_validation => false
  #科目二练车方式
  property :level_two_style, Integer, :auto_validation => false
  #科目三练车方式
  property :level_three_style, Integer, :auto_validation => false
  #拿证时间
  property :how_long, Integer, :auto_validation => false
  #服务特色
  property :special, String, :auto_validation => false
  #训练场地
  property :places, Text, :auto_validation => false
  #名额数量
  property :limit_count, Integer, :auto_validation => false, :default => 0

  has n, :users, :model => 'User'

  has n, :signups

  belongs_to :school

  belongs_to :city

  def city_name
    city.present? ? city.name : '--'
  end

  def photo_thumb_url
     photo.thumb && photo.thumb.url ? CustomConfig::HOST + photo.thumb.url : ''
  end

  def photo_url
     photo && photo.url ? CustomConfig::HOST + photo.url : ''
  end

  def info_photo_thumb_url
     info_photo.thumb && info_photo.thumb.url ? CustomConfig::HOST + info_photo.thumb.url : ''
  end

  def info_photo_url
     info_photo && info_photo.url ? CustomConfig::HOST + info_photo.url : ''
  end

  #产品介绍
  def link
    CustomConfig::HOST + "/api/v2/product_info?product_id=#{id}"
  end

  def info_img 

  end

  def can_buy 
    show == 1 && deadline > Date.today
  end

  def exam_type_demo
    '驾考类型: 1=>C1, 2=>C2'
  end

  def show_demo
    '展示: 0=>关闭, 1=>开启'
  end

  def color_demo
    '颜色: 紫色=>#967ADC, 橙色=>#EE6439, 蓝色=>#4A89DC, 绿色=> #8CC152'
  end

  def signup_num
    signups.present? ? signups.count : 0
  end

end
