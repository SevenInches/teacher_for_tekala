migration 38, :add_field_to_teacher_referee do
  up do
    modify_table :teachers do
      add_column :referee, String
    end
  end

  down do
    modify_table :teachers do
      drop_column :referee
    end
  end
end
