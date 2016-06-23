migration 84, :add_field_exam_type_to_teacher do
  up do
    modify_table :teachers do
      add_column :exam_type, Integer
    end
  end

  down do
    modify_table :teachers do
      drop_column :exam_type
    end
  end
end
