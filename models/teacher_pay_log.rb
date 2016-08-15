class TeacherPayLog
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :teacher_id, Integer
  property :pay_date, Date
  property :amounts, String

  belongs_to :teacher
end
