migration 82, :add_field_to_field_to_train_field do
  up do
    modify_table :train_fields do
      add_column :type, Integer
    end
  end

  down do
    modify_table :train_fields do
      drop_column :type
    end
  end
end
