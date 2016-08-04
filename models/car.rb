class Car
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :number, String
  property :identify, String
  property :produce_year, Integer
  property :note, String
  property :school_id, Integer
  property :branch_id, Integer
  property :train_field_id, Integer
  property :brand, String
  property :name, String
  property :exam_type, Integer
  property :open, Boolean

  has 1, :check

  belongs_to :school
  belongs_to :branch
  belongs_to :train_field


end
