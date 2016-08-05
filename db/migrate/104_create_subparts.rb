migration 104, :create_subparts do
  up do
    create_table :subparts do
      column :id, Integer, :serial => true
      column :pic, DataMapper::Property::String, :length => 255
      column :name, DataMapper::Property::String, :length => 255
      column :client, DataMapper::Property::String, :length => 255
      column :weight, DataMapper::Property::Integer
      column :route, DataMapper::Property::String, :length => 255
      column :config, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :subparts
  end
end
