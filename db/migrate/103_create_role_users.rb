migration 103, :create_role_users do
  up do
    create_table :role_users do
      column :id, Integer, :serial => true
      column :name, DataMapper::Property::String, :length => 255
      column :role_id, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :role_users
  end
end
