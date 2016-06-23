migration 87, :add_field_to_teacher_train_field do
  up do
    modify_table :teacher_train_fields do
      add_column :sort, Integer
    end
  end

  down do
    modify_table :teacher_train_fields do
      drop_column :sort
    end
  end
end
