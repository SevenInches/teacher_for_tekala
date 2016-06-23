migration 41, :create_coupons do
  up do
    create_table :coupons do
      column :id, Integer, :serial => true
      column :money, DataMapper::Property::Integer
      column :start_at, DataMapper::Property::DateTime
      column :end_at, DataMapper::Property::DateTime
      column :city_id, DataMapper::Property::Integer
      column :count, DataMapper::Property::Integer
      column :use_count, DataMapper::Property::Integer
      column :created_at, DataMapper::Property::DateTime
      column :updated_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :coupons
  end
end
