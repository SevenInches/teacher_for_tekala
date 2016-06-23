migration 95, :add_field_profession_to_user do
  up do
    modify_table :users do
      add_column :profession, Integer
    end
  end

  down do
    modify_table :users do
      drop_column :profession
    end
  end
end
