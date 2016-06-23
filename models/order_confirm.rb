class OrderConfirm
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :teacher_id, Integer
  property :user_id, Integer
  property :order_id, Integer
  #{"未选择" => 0, "接受" => 1, "拒绝" => 2} #mok 2015-08-13
  property :status, Integer, :default => 0
  property :start_at, DateTime
  property :end_at, DateTime
  property :created_at, DateTime

  belongs_to :order
  belongs_to :user


end
