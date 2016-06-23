migration 36, :add_status_to_teachers do
  up do
    modify_table :teachers do
      add_column :status, Integer
    end
  end

  down do
    modify_table :teachers do
      drop_column :status
    end
  end
end
