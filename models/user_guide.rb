class UserGuide
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :pay, Boolean, :default => false
  property :take_photo, Boolean, :default => false
  property :examination, Boolean, :default => false
  property :signup_first, Boolean, :default => false
  property :signup_second, Boolean, :default => false
  property :user_id, Integer

  belongs_to :user, :model => 'User', :child_key => 'user_id'

end
