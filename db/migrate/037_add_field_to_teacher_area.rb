migration 37, :add_field_to_teacher_area do
  up do
    modify_table :teachers do
      add_column :area, Integer
    end
  end

  down do
    modify_table :teachers do
      drop_column :area
    end
  end
end
