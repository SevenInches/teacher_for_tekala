migration 51, :add_fields_to_teachers do
  up do
    modify_table :teachers do
      add_column :training_address, String
      add_column :map, String
      add_column :training_field, String
    end
  end

  down do
    modify_table :teachers do
      drop_column :training_address
      drop_column :map
      drop_column :training_field
    end
  end
end
