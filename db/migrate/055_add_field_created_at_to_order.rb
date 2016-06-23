migration 55, :add_field_created_at_to_order do
  up do
    modify_table :orders do
      add_column :created_at, DateTime
    add_column :updated_at, DateTime
    end
  end

  down do
    modify_table :orders do
      drop_column :created_at
    drop_column :updated_at
    end
  end
end
