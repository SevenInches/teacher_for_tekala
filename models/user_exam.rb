class UserExam
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :exam_one, Integer, :default => 0
  property :exam_four, Integer, :default => 0
  property :user_id, Integer

  belongs_to :user
end
