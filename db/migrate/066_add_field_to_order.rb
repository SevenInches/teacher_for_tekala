migration 66, :add_field_to_order do
  up do
    modify_table :orders do
      add_column :discount, Float
    end
  end

  down do
    modify_table :orders do
      drop_column :discount
    end
  end
end
