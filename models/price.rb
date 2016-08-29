#计时报价
class Price
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :c1_common, Integer
  property :c2_common, Integer
  property :c1_hot, Integer
  property :c2_hot, Integer
  property :school_id, Integer
end
