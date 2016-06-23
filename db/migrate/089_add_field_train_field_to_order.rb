migration 89, :add_field_train_field_to_order do
  up do
    modify_table :orders do
      add_column :train_field_id, Integer
    end
  end

  down do
    modify_table :orders do
      drop_column :train_field_id
    end
  end
end
