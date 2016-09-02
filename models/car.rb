#车辆信息
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
  property :open, Boolean, :default => 1
  property :teacher_id, Integer
  property :created_at, DateTime

  has 1, :check

  belongs_to :school
  belongs_to :teacher
  belongs_to :branch
  belongs_to :train_field

  def exam_type_demo
    '驾考类型: 0=>未知, 1=>C1, 2=>C2'
  end

end
