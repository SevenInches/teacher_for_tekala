migration 99, :create_cars do
  up do
    create_table :cars do
      column :id, Integer, :serial => true
      column :number, DataMapper::Property::String, :length => 255
      column :identify, DataMapper::Property::String, :length => 255
      column :produce_at, DataMapper::Property::Integer
      column :note, DataMapper::Property::String, :length => 255
      column :updated_at, DataMapper::Property::DateTime
      column :created_at, DataMapper::Property::DateTime
      column :school_id, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :cars
  end
end
