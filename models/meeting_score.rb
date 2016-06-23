class MeetingScore
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :meeting_id, Integer
  property :user_id, Integer
  property :type, Integer
  property :score, Integer
  property :created_at, DateTime

  belongs_to :meeting
  belongs_to :promotion_user, :parent_key => 'user_id', :child_key => 'user_id'

  after :save, :add_score

  def add_score
  	
    if user_id
      promotion_user.score += score
      promotion_user.save
    end

  end

end
