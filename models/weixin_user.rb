class WeixinUser
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :sex, Integer
  property :avatar, String
  property :unionid, String
end
