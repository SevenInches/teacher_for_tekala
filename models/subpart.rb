class Subpart
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :pic, String
  property :name, String
  property :weight, Integer
  property :client, String
  property :route, String
  property :config, Integer, :default => 1
end
