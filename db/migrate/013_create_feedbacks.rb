migration 13, :create_feedbacks do
  up do
    create_table :feedbacks do
      column :id, Integer, :serial => true
      column :content, DataMapper::Property::String, :length => 255
      column :user_id, DataMapper::Property::Integer
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :feedbacks
  end
end
