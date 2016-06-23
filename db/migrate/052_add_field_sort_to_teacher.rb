migration 52, :add_field_sort_to_teacher do
  up do
    modify_table :teachers do
      add_column :sort, Integer
    end
  end

  down do
    modify_table :teachers do
      drop_column :sort
    end
  end
end
