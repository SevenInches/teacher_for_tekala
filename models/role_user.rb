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

  def self.authenticate(school_no, phone, password)
    school = School.first(:school_no => school_no)
    if school.present? && school.roles.present? && school.roles.role_users.present?
      user_ids  = school.roles.role_users.aggregate(:id)
      role_users = all(:id => user_ids)
      role_user = role_users.first(:conditions => ["lower(mobile) = lower(?)", phone]) if phone.present?
      if role_user && role_user.has_password?(password) && role_user.role.school
        role_user.update(:last_login_at => Time.now)
        role_user.role.school
      else
        nil
      end
    end
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

end
