migration 59, :create_push_records do
  up do
    create_table :push_records do
      column :id, Integer, :serial => true
      column :type, DataMapper::Property::Integer
      column :content, DataMapper::Property::Text
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :push_records
  end
end
