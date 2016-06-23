migration 57, :add_created_at_to_sms do
  up do
    modify_table :sms do
      add_column :created_at, DateTime
      add_column :updated_at, DateTime
    end
  end

  down do
    modify_table :sms do
      drop_column :created_at
      drop_column :updated_at
    end
  end
end
