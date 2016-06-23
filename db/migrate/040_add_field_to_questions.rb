migration 40, :add_field_to_questions do
  up do
    modify_table :questions do
      add_column :type, Integer
    end
  end

  down do
    modify_table :questions do
      drop_column :type
    end
  end
end
