class Shop
  include DataMapper::Resource

  attr_accessor :password

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :address, String
  property :rent_amount, Integer
  property :area, Integer
  property :contact_phone, String
  property :contact_user, String
  property :profile, Text   #简介
  property :logo, String     #logo
  property :config, Text     #配置
  property :created_at, DateTime
  property :updated_at, DateTime
  property :crypted_password, String, :length => 70
  property :student_count, DataMapper::Property::Integer # 招生人数
  property :consultant_count, DataMapper::Property::Integer # 咨询人数
  property :longtitude, String
  property :latitude, String
  property :school_id, Integer

  has n, :consultants
  has n, :students

  belongs_to :school

  before :save, :encrypt_password

  def self.authenticate(phone, password)
    shop = first(:conditions => ["lower(contact_phone) = lower(?)", phone]) if phone.present?
    shop && shop.has_password?(password) ? shop : nil
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

  def student_count_today
    today_beginning = Date.strptime(Time.now.beginning_of_day.to_s,'%Y-%m-%d')
    today = today_beginning  .. Date.tomorrow
    amount = Student.all(:created_at => today).count
  end

  def student_count_month
    month_beginning = Date.strptime(Time.now.beginning_of_month.to_s,'%Y-%m-%d')
    this_month = month_beginning .. Date.tomorrow
    amount = Student.all(:created_at => this_month).count
  end


end