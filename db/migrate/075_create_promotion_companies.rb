migration 75, :create_promotion_companies do
  up do
    create_table :promotion_companies do
      column :id, Integer, :serial => true
      column :name, DataMapper::Property::String, :length => 255
      column :logo, DataMapper::Property::String, :length => 255
      column :desc, DataMapper::Property::String, :length => 255
      column :count, DataMapper::Property::Integer
      column :created_at, DataMapper::Property::DateTime
      column :sort, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :promotion_companies
  end
end
