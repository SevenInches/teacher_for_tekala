#驾校校区
class Branch
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :school_id, Integer
  property :type, Integer
  property :phone, String
  property :open, Boolean
  property :weight, Integer
  property :found_at, Date

  belongs_to :school
  has n, :user
  has n, :car

end
