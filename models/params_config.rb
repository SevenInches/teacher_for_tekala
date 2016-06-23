class ParamsConfig
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :value, String
  property :remark, String
  property :created_at, DateTime
  property :updated_at, Time
end
