class Shop
  include DataMapper::Resource

  attr_accessor :password

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :address, String
  property :contact_phone, String
  property :profile, Text   #简介
  property :logo, String     #logo
  property :config, Text     #配置
  property :created_at, DateTime
  property :updated_at, DateTime
  property :crypted_password, String, :length => 70
  property :student_count, DataMapper::Property::Integer # 招生人数
  property :consultant_count, DataMapper::Property::Integer # 咨询人数

  has n, :consultants
  has n, :students

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

  #def user_num
   # month_beginning = Date.strptime(Time.now.beginning_of_month.to_s,'%Y-%m-%d')
    #this_month = month_beginning  .. Date.tomorrow
    #users.count(:signup_at => this_month)
 # end

  #def signup_amount
    #month_beginning = Date.strptime(Time.now.beginning_of_month.to_s,'%Y-%m-%d')
    #this_month = month_beginning  .. Date.tomorrow
    #amount = signups.all(:created_at => this_month, :status => 2).sum(:amount)
    #amount.present? ? amount.round(2) : 0
  #end

  def signup_amount_demo
    '本月营收'
  end

  def user_num_demo
    '本月招生'
  end

end