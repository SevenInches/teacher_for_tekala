class Car
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :number, String
  property :identify, String
  property :produce_year, Integer
  property :note, String
  property :school_id, Integer
  property :brand, String
  property :name, String

  belongs_to :school
end
