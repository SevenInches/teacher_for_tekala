migration 24, :add_field_to_user do
  up do
    modify_table :users do
      add_column :motto, String
    end
  end

  down do
    modify_table :users do
      drop_column :motto
    end
  end
end
