migration 76, :create_promotion_user_fours do
  up do
    create_table :promotion_user_fours do
      column :id, Integer, :serial => true
      column :name, DataMapper::Property::String, :length => 255
      column :tel, DataMapper::Property::String, :length => 255
      column :age, DataMapper::Property::Integer
      column :company_id, DataMapper::Property::Integer
      column :role, DataMapper::Property::Integer
      column :local, DataMapper::Property::Boolean
      column :area, DataMapper::Property::Integer
      column :created_at, DataMapper::Property::DateTime
    end
  end

  down do
    drop_table :promotion_user_fours
  end
end
