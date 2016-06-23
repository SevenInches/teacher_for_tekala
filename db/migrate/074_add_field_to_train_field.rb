migration 74, :add_field_to_train_field do
  up do
    modify_table :train_fields do
      add_column :area, Integer
    end
  end

  down do
    modify_table :train_fields do
      drop_column :area
    end
  end
end
