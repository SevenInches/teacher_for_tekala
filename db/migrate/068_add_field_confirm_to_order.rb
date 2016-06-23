migration 68, :add_field_confirm_to_order do
  up do
    modify_table :orders do
      add_column :confirm, Integer
    end
  end

  down do
    modify_table :orders do
      drop_column :confirm
    end
  end
end
