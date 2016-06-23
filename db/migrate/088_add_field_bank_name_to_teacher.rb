migration 88, :add_field_bank_name_to_teacher do
  up do
    modify_table :teachers do
      add_column :bank_name, String
    end
  end

  down do
    modify_table :teachers do
      drop_column :bank_name
    end
  end
end
