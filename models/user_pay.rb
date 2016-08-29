#用户缴费记录
class UserPay
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :pay_at, Date
  property :amount, String
  property :explain, String
  property :user_id, Integer
end
