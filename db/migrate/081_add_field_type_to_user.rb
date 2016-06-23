migration 81, :add_field_type_to_user do
  up do
    modify_table :users do
      add_column :type, Integer
    end

    modify_table :orders do
      add_column :type, Integer
    end

  end

  down do
    modify_table :users do
      drop_column :type
    end

    modify_table :orders do
      drop_column :type
    end
    
  end
end
