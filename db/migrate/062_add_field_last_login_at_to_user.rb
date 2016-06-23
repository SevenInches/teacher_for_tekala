migration 62, :add_field_last_login_at_to_user do
  up do
    modify_table :users do
      add_column :last_login_at, DateTime
    add_column :device, String
    end
  end

  down do
    modify_table :users do
      drop_column :last_login_at
    drop_column :device
    end
  end
end
