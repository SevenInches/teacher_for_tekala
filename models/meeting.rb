class Meeting
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :start_at, DateTime
  property :end_at, DateTime
  property :name, String
  property :desc, String
  property :created_at, DateTime

  has n, :meeting_scores
end
