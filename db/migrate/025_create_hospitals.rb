migration 25, :create_hospitals do
  up do
    create_table :hospitals do
      column :id, Integer, :serial => true
      column :city_id, DataMapper::Property::Integer
      column :name, DataMapper::Property::String, :length => 255
      column :address, DataMapper::Property::String, :length => 255
      column :latitude, DataMapper::Property::String, :length => 255
      column :longitude, DataMapper::Property::String, :length => 255
      column :note, DataMapper::Property::String, :length => 255
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :hospitals
  end
end
