migration 91, :add_field_exam_type_to_user do
  up do
    modify_table :users do
      add_column :exam_type, Integer
    end
  end

  down do
    modify_table :users do
      drop_column :exam_type
    end
  end
end
