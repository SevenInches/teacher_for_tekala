migration 45, :create_promotion_users do
  up do
    create_table :promotion_users do
      column :id, Integer, :serial => true
      column :user_id, DataMapper::Property::Integer
      column :number, DataMapper::Property::Integer
      column :normal_photo, DataMapper::Property::String, :length => 255
      column :meng_photo, DataMapper::Property::String, :length => 255
      column :score, DataMapper::Property::Integer
      column :level, DataMapper::Property::Integer
      column :motto, DataMapper::Property::String, :length => 255
      column :created_at, DataMapper::Property::DateTime
      column :updated_at, DataMapper::Property::DateTime
    end

    create_index :promotion_users, :number
    
  end

  down do
    drop_table :promotion_users
  end
end
