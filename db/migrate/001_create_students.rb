migration 1, :create_students do
  up do
    create_table :students do
      column :id, Integer, :serial => true
      column :name, DataMapper::Property::String, :length => 255
      column :age, DataMapper::Property::Integer
      column :sex, DataMapper::Property::Integer
      column :exam_type, DataMapper::Property::Integer
      column :like_train_field_id, DataMapper::Property::Integer
      column :mobile, DataMapper::Property::String, :length => 255

      column :created_at, DataMapper::Property::DateTime
      column :updated_at, DataMapper::Property::DateTime
  end
end

  down do
    drop_table :students
  end
end