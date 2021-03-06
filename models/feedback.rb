#建议反馈
class Feedback
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :content, String, :required => true, :messages => {:presence  => "内容不能为空"}
  property :user_id, Integer
  property :created_at, DateTime
  property :school_id, Integer

  belongs_to :user
  belongs_to :school

end
