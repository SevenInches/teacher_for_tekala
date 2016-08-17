class Subpart
  include DataMapper::Resource

  attr_accessor :count

  # property <name>, <type>
  property :id, Serial
  property :pic, String
  property :name, String
  property :weight, Integer
  property :client, String
  property :route, String
  property :config, Integer, :default => 1

  def config_demo
    '内容配置: 1 =>APP , 2 => WEB'
  end
end
