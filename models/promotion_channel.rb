class PromotionChannel
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :from, String
  property :created_at, DateTime
  property :event, String
  property :event_key, Integer
end
