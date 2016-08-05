class RoleUser
  include DataMapper::Resource
  attr_accessor :password

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :role_id, Integer
  property :mobile, String
  property :crypted_password, String
  property :last_login_at, DateTime
  property :created_at, DateTime

  belongs_to :role

  before :save, :encrypt_password

  def encrypt_password
    self.crypted_password  = ::BCrypt::Password.create(password) if password.present?
  end
end
