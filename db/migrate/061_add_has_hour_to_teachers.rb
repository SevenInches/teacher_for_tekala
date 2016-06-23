migration 61, :add_has_hour_to_teachers do
  up do
    modify_table :teachers do
      add_column :has_hour, Integer
    end
  end

  down do
    modify_table :teachers do
      drop_column :has_hour
    end
  end
end
