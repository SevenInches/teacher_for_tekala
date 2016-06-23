migration 49, :create_meetings do
  up do
    create_table :meetings do
      column :id, Integer, :serial => true
      column :start_at, DataMapper::Property::DateTime
      column :end_at, DataMapper::Property::DateTime
      column :name, DataMapper::Property::String, :length => 255
      column :desc, DataMapper::Property::String, :length => 255
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :meetings
  end
end
