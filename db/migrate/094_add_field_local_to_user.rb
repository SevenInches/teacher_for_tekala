migration 94, :add_field_local_to_user do
  up do
    modify_table :users do
      add_column :local, Integer
    end
  end

  down do
    modify_table :users do
      drop_column :local
    end
  end
end
