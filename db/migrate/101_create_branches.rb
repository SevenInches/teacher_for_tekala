migration 101, :create_branches do
  up do
    create_table :branches do
      column :id, Integer, :serial => true
      column :name, DataMapper::Property::String, :length => 255
      column :school_id, DataMapper::Property::Integer
      column :type, DataMapper::Property::Integer
      column :phone, DataMapper::Property::String, :length => 255
      column :open, DataMapper::Property::Boolean
      column :weight, DataMapper::Property::Integer
      column :found_at, DataMapper::Property::Date
    end
  end

  down do
    drop_table :branches
  end
end
