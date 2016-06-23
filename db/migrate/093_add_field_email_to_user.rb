migration 93, :add_field_email_to_user do
  up do
    modify_table :users do
      add_column :email, String
    add_column :work_area, Integer
    add_column :live_area, Integer
    end
  end

  down do
    modify_table :users do
      drop_column :email
    drop_column :work_area
    drop_column :live_area
    end
  end
end
