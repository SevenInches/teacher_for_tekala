class WithdrawLog
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :amounts, Integer
  property :teacher_id, Integer
  # 状态{"提现中"=>1,"已提现"=>2}
  property :status, Integer, :default => 1
  property :note, String
  property :created_at, DateTime

  belongs_to :teacher
  def self.confirm
    self.status = 2
    self.save
  end
end
