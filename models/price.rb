#计时报价
class Price
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :c1_common, String
  property :c2_common, String
  property :c1_hot, String
  property :c2_hot, String
  property :school_id, Integer
end
