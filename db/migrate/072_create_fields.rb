migration 72, :create_fields do
  up do
    create_table :train_fields do
      column :id, Integer, :serial => true
      column :name, DataMapper::Property::String, :length => 255
      column :address, DataMapper::Property::String, :length => 255
      column :longitude, DataMapper::Property::String, :length => 255
      column :latitude, DataMapper::Property::String, :length => 255
      column :remark, DataMapper::Property::String, :length => 255
      column :count, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :fields
  end
end
