migration 102, :create_roles do
  up do
    create_table :roles do
      column :id, Integer, :serial => true
      column :name, DataMapper::Property::String, :length => 255
      column :role, DataMapper::Property::Integer, :length => 255
    end
  end

  down do
    drop_table :roles
  end
end
