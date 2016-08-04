class Product
  include DataMapper::Resource

  property :id, Serial
  property :city_id, Integer
  property :name, String
  property :promotion, String
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

  has n, :users, :model => 'User'

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

end
