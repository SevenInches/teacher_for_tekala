migration 29, :add_field_to_new do
  up do
    modify_table :news do
      add_column :pv, Integer
    end
  end

  down do
    modify_table :news do
      drop_column :pv
    end
  end
end
