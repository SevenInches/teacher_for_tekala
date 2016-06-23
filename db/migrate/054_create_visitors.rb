migration 54, :create_visitors do
  up do
    create_table :visitors do
      column :id, Integer, :serial => true
      column :name, DataMapper::Property::String, :length => 255
      column :sex, DataMapper::Property::Integer
      column :age, DataMapper::Property::Integer
      column :mobile, DataMapper::Property::String, :length => 255
      column :area, DataMapper::Property::Integer
      column :industry, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :visitors
  end
end
