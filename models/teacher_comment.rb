class TeacherComment
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :user_id, Integer
  property :teacher_id, Integer
  property :rate, Integer, :default => 5
  property :content, Text, :lazy => false 
  property :created_at, DateTime
  property :anonymous, Integer, :default => 0

  #一个订单一条评论
  property :order_id, Integer

  belongs_to :user
  belongs_to :teacher
  belongs_to :order

  has n, :photos, :model => 'CommentPhoto', :child_key =>'comment_id' , :constraint => :destroy
  
  def created_format
    
  end
end
