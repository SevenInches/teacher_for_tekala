migration 53, :add_field_status_flag_to_teacher do
  up do
    modify_table :teachers do
      add_column :status_flag, Integer
    end
  end

  down do
    modify_table :teachers do
      drop_column :status_flag
    end
  end
end
