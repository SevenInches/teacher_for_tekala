migration 73, :create_teacher_fields do
  up do
    create_table :teacher_train_fields do
      column :id, Integer, :serial => true
      column :teacher_id, DataMapper::Property::Integer
      column :train_field_id, DataMapper::Property::Integer
    end
  end

  down do
    drop_table :teacher_train_fields
  end
end
