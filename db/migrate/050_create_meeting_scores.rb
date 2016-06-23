migration 50, :create_meeting_scores do
  up do
    create_table :meeting_scores do
      column :id, Integer, :serial => true
      column :meeting_id, DataMapper::Property::Integer
      column :user_id, DataMapper::Property::Integer
      column :type, DataMapper::Property::Integer
      column :score, DataMapper::Property::Integer
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :meeting_scores
  end
end
