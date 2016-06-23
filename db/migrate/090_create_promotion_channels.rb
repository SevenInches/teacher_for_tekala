migration 90, :create_promotion_channels do
  up do
    create_table :promotion_channels do
      column :id, Integer, :serial => true
      column :from, DataMapper::Property::String, :length => 255
      column :created_at, DataMapper::Property::DateTime
      column :event, DataMapper::Property::String, :length => 255
      column :event_key, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :promotion_channels
  end
end
