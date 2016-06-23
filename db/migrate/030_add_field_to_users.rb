migration 30, :add_field_to_users do
  up do
    modify_table :users do
      add_column :age, Integer
    end
  end

  down do
    modify_table :users do
      drop_column :age
    end
  end
end
