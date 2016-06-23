migration 28, :add_field_to_ads do
  up do
    modify_table :ads do
      add_column :pv, Integer
    end
  end

  down do
    modify_table :ads do
      drop_column :pv
    end
  end
end
