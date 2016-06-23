class Hospital
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :city_id, Enum[0], :default => 0
  property :name, String
  property :address, String
  property :latitude, String
  property :longitude, String
  property :note, String
  property :created_at, DateTime

  def self.get_city
    return {'深圳市'=>'0'}
  end

  def set_city
    case self.city_id
    when 0
      return '深圳市'
    end
  end
end
