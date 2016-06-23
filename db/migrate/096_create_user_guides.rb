migration 96, :create_user_guides do
  up do
    create_table :user_guides do
      column :id, Integer, :serial => true
      column :pay, DataMapper::Property::Boolean
      column :take_photo, DataMapper::Property::Boolean
      column :examination, DataMapper::Property::Boolean
      column :signup_first, DataMapper::Property::Boolean
      column :signup_second, DataMapper::Property::Boolean
      column :user_id, DataMapper::Property::Integer
      
    end
  end

  down do
    drop_table :user_guides
  end
end
